using Random

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

function greedy(data)
  degree = zeros(Int, data.n)

  for i in 1:data.n
    for j in 1:i-1
      if data.g[i, j] == 1
        degree[i] += 1
        degree[j] += 1
      end
    end
  end

  vertices = Array{Tuple{Int,Int}}(undef, data.n)

  for i in 1:data.n
    vertices[i] = (degree[i], i)
  end

  maximum_independet_set = Int[]

  sort!(vertices)

  # greedy first
  for i in 1:data.n
    can_insert = true

    for j in maximum_independet_set
      if data.g[vertices[i][2], j] == 1
        can_insert = false
      end
    end

    if can_insert == true
      push!(maximum_independet_set, vertices[i][2])
    end
  end

  # random
  for _ in 1:10000
    shuffle!(vertices)

    solution = Int[]

    for i in 1:data.n
      can_insert = true
  
      for j in solution
        if data.g[vertices[i][2], j] == 1
          can_insert = false
        end
      end
  
      if can_insert == true
        push!(solution, vertices[i][2])
      end
    end

    if length(solution) > length(maximum_independet_set)
      maximum_independet_set = copy(solution)
    end
  end
  
  return maximum_independet_set
end

function certificate(solution)
  sort!(solution)

  for i in solution
    print("$(i)\t")
  end

  println()
end

function main()
  file = open(ARGS[1], "r")
  data = read_input(file)

  solution = greedy(data)

  println("TP2 2021421869 = $(length(solution))")
  certificate(solution)
end

main()
