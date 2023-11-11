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

function max_degree_node(data)
  max_degree = -1
  max_degree_idx = -1

  for i in 1:data.n
    number_of_neighbors = length(data.g[i])
    if number_of_neighbors > max_degree
      max_degree = number_of_neighbors
      max_degree_idx = i
    end
  end

  return max_degree_idx
end

function max_saturation_node()
end

function DSatur(data)
  colors_used = []

  available_vertices = [i for i in 1:data.n]

  colors = Array{Int}(undef, data.n)
  fill!(colors, -1)

  degree = Array{Tuple{Int,Int}}(undef, data.n)
  for i in 1:data.n
    degree[i] = (0, i)
  end

  max_degree_idx = max_degree_node(data)

  colors[max_degree_idx] = 1
  filter!(x -> x != max_degree_idx, available_vertices)
  for i in data.g[max_degree_idx]
    degree[i][1] += 1
  end

  # println(degree)

  # push!(colors_used, 1)

  # while length(available_vertices) > 0

  # end
end

function certificate(solution, boxes, data)
end

function main()
  file = open(ARGS[1], "r")
  data = read_input(file)

  solution = DSatur(data)

  # certificate(solution, boxes, data)
end

main()
