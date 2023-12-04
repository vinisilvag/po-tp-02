mutable struct LotSizing
  n::Int
  c::Array{Float64} # custo de producao
  d::Array{Float64} # demanda
  h::Array{Float64} # custo de estocagem
  p::Array{Float64} # valor da multa
end

function read_input(file)
  n = 0
  c = []
  d = []
  h = []
  p = []

  for line in eachline(file)
    q = split(line, "\t")

    if q[1] == "n"
      n = parse(Int64, q[2])
      c = [0.0 for i = 1:n]
      d = [0.0 for i = 1:n]
      h = [0.0 for i = 1:n]
      p = [0.0 for i = 1:n]
    elseif q[1] == "c"
      index = parse(Int64, q[2])
      c[index] = parse(Float64, q[3])
    elseif q[1] == "d"
      index = parse(Int64, q[2])
      d[index] = parse(Float64, q[3])
    elseif q[1] == "s"
      index = parse(Int64, q[2])
      h[index] = parse(Float64, q[3])
    elseif q[1] == "p"
      index = parse(Int64, q[2])
      p[index] = parse(Float64, q[3])
    end
  end

  return LotSizing(n, c, d, h, p)
end

function solve(data)
  solution = [0 for _ in 1:data.n]
  cost = 0
  
  for i in 1:data.n
    today = data.d[i] * data.c[i]

    before_idx = -1
    before = Inf
    
    after_idx = -1
    after = Inf

    for j in 1:i-1
      past = data.d[i] * data.c[j]
      storage = 0

      for k in j:i-1
        storage += data.d[i] * data.h[k]
      end

      if past + storage < before
        before = past + storage
        before_idx = j
      end
    end

    for j in i+1:data.n
      future = data.d[i] * data.c[j]
      penalty = 0

      for k in i:j-1
        penalty += data.d[i] * data.p[k]
      end

      if future + penalty < after
        after = future + penalty
        after_idx = j
      end
    end

    min_cost = min(today, before, after)

    if before == min_cost
      solution[before_idx] += data.d[i]
      cost += before
    elseif after == min_cost
      solution[after_idx] += data.d[i]
      cost += after
    else
      solution[i] += data.d[i]
      cost += today
    end
  end

  return cost, solution
end

function certificate(data, solution)
  for i in 1:data.n
    print("$(solution[i])\t")
  end

  println()
end

function main()
  file = open(ARGS[1], "r")
  data = read_input(file)

  best, solution = solve(data)

  println("TP2 2021421869 = $(best)")
  certificate(data, solution)
end

main()
