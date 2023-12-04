mutable struct Graph
  n::Int
  g::Array{Array{Int}}
  w::Matrix{Float64}
end

function read_input(file)
  n = 0
  g = [[]]
  w = [[]]

  for line in eachline(file)
    q = split(line, "\t")

    if q[1] == "n"
      n = parse(Int64, q[2])
      g = [[] for _ = 1:n]
      w = zeros(Float64, (n, n))
    elseif q[1] == "e"
      v = parse(Int64, q[2])
      u = parse(Int64, q[3])
      ww = parse(Float64, q[4])

      push!(g[v], u)
      push!(g[u], v)

      w[v, u] = ww
      w[u, v] = ww
    end
  end

  return Graph(n, g, w)
end

function sum_edges(data, solution)
  total = 0

  for i in 1:data.n
    for j in i+1:data.n
      if solution[i] == 1 && solution[j] == 1
        total += data.w[i, j]
      end
    end
  end

  return total
end

function greedy(data)
  sum = [0 for i in 1:data.n]
  solution = [1 for _ in 1:data.n]

  for i in 1:data.n
    for j in data.g[i]
      sum[i] += data.w[i, j]
    end
  end

  while true
    (min_val, min_idx) = findmin(sum)

    if min_val >= 0
      break
    end

    for i in 1:data.n
      if solution[i] == 1 && min_idx in data.g[i]
        sum[i] -= data.w[i, min_idx]
      end
    end

    solution[min_idx] = 0
    sum[min_idx] = 0
  end

  return sum_edges(data, solution), solution
end

function one_node_swap(data, solution, i, j)
  new_sol = copy(solution)
  
  new_sol[i] = 0
  new_sol[j] = 1

  return sum_edges(data, new_sol), new_sol
end

function local_search(data)
  best, solution = greedy(data)

  is_improving = true

  while is_improving
    is_improving = false

    for i in 1:data.n
      for j in 1:data.n
        if solution[i] == 0
          break
        end
  
        if solution[j] == 1
          continue
        end
  
        local_opt, local_sol = one_node_swap(data, solution, i, j)
  
        if local_opt > best
          best = local_opt
          solution = local_sol
          is_improving = true
        end
      end
    end
  end

  return best, solution
end

function certificate(data, solution)
  for i in 1:data.n
    if solution[i] == 1
      print("$(i)\t")
    end
  end

  println()
end

function main()
  file = open(ARGS[1], "r")
  data = read_input(file)

  best, solution = local_search(data)

  println("TP2 2021421869 = $(best)")
  certificate(data, solution)
end

main()
