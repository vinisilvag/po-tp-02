using DataStructures
using StatsBase

mutable struct Graph
  n::Int
  g::Matrix{Int}
end

function read_input(file)
  n = 0
  g = [[]]

  for line in eachline(file)
    q = split(line, "\t")

    if q[1] == "n"
      n = parse(Int64, q[2])
      g = zeros(Int, (n, n))
    elseif q[1] == "e"
      v = parse(Int64, q[2])
      u = parse(Int64, q[3])
      g[u, v] = 1
      g[v, u] = 1
    end
  end

  return Graph(n, g)
end

function get_neighbors(data, u)
  neighbors = Int[]

  for i in 1:data.n
    if data.g[u, i] == 1
      push!(neighbors, i)
    end
  end

  return neighbors
end

function is_valid_coloring(data, individual)
  is_valid = true

  for i in 1:data.n
    neighbors = get_neighbors(data, i)

    for j in neighbors
      if individual[i] == individual[j]
        is_valid = false
      end
    end
  end

  return is_valid
end

function generate_individual(data)
  individual = Array{Int}

  while true
    individual = rand(1:data.n, data.n)

    !is_valid_coloring(data, individual) || break
  end

  return individual
end

function number_of_colors(individual)
  return length(Set(individual))
end

function crossover()
end

function select()
end

function replace()
end

# n: # da populacao
# iter: # de iteracoes
# alfa: porcentagem da populacao que sofre mutacao
# beta: porcentagem da populacao que se recombina
function genetic(data, n, iter, alfa, beta)
  best = data.n
  colors = Vector{Int}

  population = MutableBinaryMinHeap{Tuple{Int,Vector{Int}}}()

  for _ in 1:n
    individual = generate_individual(data)
    push!(population, (number_of_colors(individual), individual))
  end

  for _ in 1:iter
    for _ in 1:((n*beta)/2)
      p1 = -1
      p2 = -1

      while true
        p1 = floor(Int, rand(1:(n*beta)))
        p2 = floor(Int, rand(1:(n*beta)))

        p1 == p2 || break
      end

      # offspring = crossover()

      # push!(population, (number_of_colors(offspring), offspring))
    end
  end
end

function main()
  file = open(ARGS[1], "r")
  data = read_input(file)

  solution = genetic(data, 100, 100, 0.6, 0.4)

  # certificate(solution, boxes, data)
end

main()
