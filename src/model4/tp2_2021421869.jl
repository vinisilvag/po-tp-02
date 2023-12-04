using DataStructures

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

function DSatur(data)
  colors = [0 for _ = 1:data.n]
  satur = [[] for i in 1:data.n]
  pq = PriorityQueue{Int, Tuple{Int, Int}}(Base.Order.Reverse)

  for i in 1:data.n
    push!(pq, i => (0, length(data.g[i])))
  end

  while !isempty(pq)
    node = first(pq)
    delete!(pq, node.first)

    if colors[node.first] != 0
      continue
    end

    curr_color = 0

    while colors[node.first] == 0
      curr_color += 1

      if !(curr_color in satur[node.first])
        colors[node.first] = curr_color
      end
    end

    for neighbor in data.g[node.first]
      if colors[neighbor] == 0 && !(curr_color in satur[neighbor])
        push!(satur[neighbor], curr_color)
        push!(pq, neighbor => (length(satur[neighbor]), length(data.g[neighbor])))
      end
    end
  end

  best = length(Set(colors))

  return best, colors
end

function certificate(data, best, colors)
  class_list = [[] for _ in 1:best]

  for i in 1:data.n
    push!(class_list[colors[i]], i)
  end

  for i in 1:best
    sort!(class_list[i])
  end

  for i in 1:best
    # print("$(i) COR: ")
    for v in class_list[i]
      print("$(v)\t")
    end

    println()
  end
end

function main()
  file = open(ARGS[1], "r")
  data = read_input(file)

  best, colors = DSatur(data)

  println("TP2 2021421869 = $(best)")
  certificate(data, best, colors)
end

main()
