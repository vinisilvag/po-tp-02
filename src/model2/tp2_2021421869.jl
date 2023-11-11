mutable struct Graph
  n::Int
  g::Array{Array{Int}}
end

function read_input(file)
  n = 0
  g = [[]]

  for line in eachline(file)
    q = split(line, "\t")

    if q[1] == "n"
      n = parse(Int64, q[2])
      g = [[] for _ = 1:n]
    elseif q[1] == "e"
      v = parse(Int64, q[2])
      u = parse(Int64, q[3])
      push!(g[v], u)
      push!(g[u], v)
    end
  end

  return Graph(n, g)
end

function solve(data)
  label = [i for i in 1:data.n]
  adj = zeros(Int, data.n, data.n)
  degree = zeros(Int, data.n)

  for i in 1:data.n
    for j in data.g[i]
      adj[i, j] = 1
      adj[j, i] = 1
    end
  end

  for i in 1:data.n
    for j in 1:i-1
      if adj[i, j] == 1
        degree[i] += 1
        degree[j] += 1
      end
    end
  end

  vertices = Array{Tuple{Int,Int}}(undef, data.n)

  for i in 1:data.n
    vertices[i] = (degree[i], i)
  end

  sort!(vertices)

  maximum_independet_set = Int[]

  for i in 1:data.n
    can_insert = true

    # compartilha aresta com algum vertice na solucao?
    for j in maximum_independet_set
      if adj[vertices[i][2], j] == 1
        can_insert = false
      end
    end

    # senao, insere
    if can_insert == true
      push!(maximum_independet_set, vertices[i][2])
    end
  end

  return maximum_independet_set
end

function certificate(solution)
  println("NUMERO DE VERTICES NO CONJUNTO: $(length(solution))")
  sort!(solution)

  for i in solution
    print("$(i) ")
  end

  println()
end

function main()
  file = open(ARGS[1], "r")
  data = read_input(file)

  solution = solve(data)

  certificate(solution)
end

main()
