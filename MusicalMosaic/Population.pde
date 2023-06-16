import java.util.*; // Needed to sort arrays

// This class manages a group of individuals.
class Population {
  
  Individual[] individuals;
  int generations; 
  
  // Create population
  Population() {
    individuals = new Individual[population_size];
    initialize();
  }
  
  // Initialize population with random individuals
  void initialize() {
    for (int i = 0; i < individuals.length; i++) {
      individuals[i] = new Individual();
    }
    
    // Set initial fitness of individuals to 0
    for (int i = 0; i < individuals.length; i++) {
      individuals[i].setFitness(0);
    }
    
    // Reset generations counter
    generations = 0;
  }
  
  // Create the next generation
  void evolve() {
    // Create a new a array to store the individuals that will be in the next generation
    Individual[] new_generation = new Individual[individuals.length];
    
    // Sort individuals by fitness
    sortIndividualsByFitness();
    
    // Copy the elite to the next generation
    for (int i = 0; i < elite_size; i++) {
      new_generation[i] = individuals[i].getCopy();
    }
    
    // Create (breed) new individuals with crossover
    for (int i = elite_size; i < new_generation.length; i++) {
      if (random(1) <= crossover_rate) {
        Individual parent1 = tournamentSelection();
        Individual parent2 = tournamentSelection();
        Individual child = parent1.onePointCrossover(parent2);
        new_generation[i] = child;
      } else {
        new_generation[i] = tournamentSelection().getCopy();
      }
    }
    
    // Mutate new individuals
    for (int i = elite_size; i < new_generation.length; i++) {
       new_generation[i].mutate();
    }
    
    // Replace the individuals in the population with the new generation individuals
    for (int i = 0; i < individuals.length; i++) {
      individuals[i] = new_generation[i];
    }
    
    // Reset the fitness of all individuals to 0, excluding elite
    for (int i = 0; i < individuals.length; i++) {
       individuals[i].setFitness(0);
    }
    
    // Increment the number of generations
    generations++;
    println(generations);
  }
  
  // Select one individual using a tournament selection 
  Individual tournamentSelection() {
    // Select a random set of individuals from the population
    Individual[] tournament = new Individual[tournament_size];
    for (int i = 0; i < tournament.length; i++) {
      int random_index = int(random(0, individuals.length));
      tournament[i] = individuals[random_index];
    }
    // Get the fittest individual from the selected individuals
    Individual fittest = tournament[0];
    for (int i = 1; i < tournament.length; i++) {
      if (tournament[i].getFitness() > fittest.getFitness()) {
        fittest = tournament[i];
      }
    }
    return fittest;
  }
  
  // Sort individuals in the population by fitness in descending order (fittest first)
  void sortIndividualsByFitness() {
    Arrays.sort(individuals, new Comparator<Individual>() {
      public int compare(Individual indiv1, Individual indiv2) {
        return Float.compare(indiv2.getFitness(), indiv1.getFitness());
      }
    });
  }
  
  Individual getIndiv(int index) {
    return individuals[index];
  }
  
  int getSize() {
    return individuals.length;
  }
  
  // Get the number of generations that have been created so far
  int getGenerations() {
    return generations;
  }
}
