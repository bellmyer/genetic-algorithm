Dir[File.dirname(__FILE__) + '/lib/*.rb'].each{|f| require f} 
require 'date'

class GeneticAlgorithm
  attr_reader :directory, :solution_class, :values, :options, :population, :generation, :total_score, :log_start, :log_file
  
  DEFAULTS = {
    population_size: 50,
    generations: 1000,
    mutation_rate: 0.05,
    holdover_rate: 0.1,
    top_score: nil,
    display: 1,
    verbose: false
  }
  
  def initialize directory, solution_class, ranges, options={}
    @options = DEFAULTS.merge(options)
    @options[:top_score] ||= solution_class.top_score

    @directory = directory
    `mkdir -p #{directory}` unless File.exists?(directory)
    `rm #{directory}/*.ga` unless Dir["#{directory}/*.ga"].empty?
    
    @solution_class = solution_class
    @values = ranges.map(&:to_a)
    @generation = 0
    
    init_log
    create_population
  end
  
  def population_by_fitness
    return @population_by_fitness if defined?(@population_by_fitness)
    @population_by_fitness = population.sort_by{|p| 0-p[:score]}
  end
  
  def run
    @log_start = Time.now
    
    while generation < options[:generations] && best[:score] < options[:top_score] do
      break if best[:score] >= options[:top_score]
      regenerate_population
    end
    
    best[:score]
  end

  def init_log
    @log_start = Time.now
    @log_file = File.open("#{directory}/#{Time.now.strftime('%Y%m%d-%H%M%S')}.log", 'w')

    header = "generation,timestamp,worst,best,highest,progress"
    values.size.times{|i| header += ",value #{i}"}
    
    @log_file.puts header
    @log_file.flush
  end
  
  def log_generation
    return unless (generation % options[:display]) == 0
    
    stamp = DateTime.strptime((Time.now - log_start).to_s, '%s').strftime('%H:%M:%S')

    best_percent = (best[:score].to_f / options[:top_score].to_f).round(4)
    worst_percent = (worst[:score].to_f / options[:top_score].to_f).round(4)
    
    results = [generation, stamp, worst_percent, best_percent, best[:display]]

    log_file.puts results.join(',')
    log_file.flush
    
    puts results.join('    ')
  end
  
  def create_population
    @population = []
    
    @options[:population_size].times do
      params = values.map{|value| select_random(value)}
      @population << create_individual(params)
      @total_score = @population.map{|p| p[:score]}.reduce(:+)
    end
    
    save
  end
  
  def regenerate_population
    new_population = holdovers
    
    while new_population.size < options[:population_size] do
      puts "building #{new_population.size}:" if options[:verbose]
      
      params = (0...values.size).map{|i| mutate? ? select_random(values[i]) : select_by_fitness(i)}
      new_population << create_individual(params)
    end
    
    @population = new_population
    @total_score = @population.map{|p| p[:score]}.reduce(:+)
    remove_instance_variable :@population_by_fitness if defined?(@population_by_fitness)
    
    save
  end
  
  def mutate?
    rand < options[:mutation_rate]
  end
  
  def holdovers
    holdover_count = (options[:population_size] * options[:holdover_rate]).to_i
    population_by_fitness[0,holdover_count]
  end
  
  def select_by_fitness param_index
    low_score = worst[:score]
    picked = rand(total_score - (low_score * population.size))
    
    puts "    #{picked[:display]}[#{param_index}]" if options[:verbose]

    population.detect{ |i| (picked -= i[:score] - low_score) <= 0 }[:params][param_index]
  end
  
  def create_individual params
    individual = solution_class.new(*params)
    {params: params, score: individual.score, display: individual.to_s}
  end
  
  def save
    File.open(sprintf("%s/%06d.ga", directory, generation), 'wb') do |f|
      f.write Marshal.dump(population_by_fitness)
    end
    
    log_generation
    
    @generation += 1
  end
  
  def select_random list
    list[rand(list.size)]
  end
  
  def best
    population_by_fitness.first
  end
  
  def worst
    population_by_fitness.last
  end
end