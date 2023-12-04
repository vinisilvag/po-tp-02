mutable struct Packing
  n::Int
  w::Array{Tuple{Float64,Int}}
  B::Int
end

function read_input(file)
  n = 0
  w = []

  for line in eachline(file)
    q = split(line, "\t")

    if q[1] == "n"
      n = parse(Int64, q[2])
      w = [(0.0, -1) for i = 1:n]
    elseif q[1] == "o"
      index = parse(Int64, q[2])
      w[index+1] = (parse(Float64, q[3]), index)
    end
  end

  return Packing(n, w, 20)
end

function sorted_greedy(data)
  boxes = [[] for _ in 1:data.n]
  weights = zeros(data.n)

  data.w = sort(data.w, rev=true)

  solution = 0

  for i in 1:data.n
    for j in 1:data.n
      if data.B - weights[j] > data.w[i][1]
        if weights[j] == 0.0
          solution += 1
        end

        push!(boxes[j], data.w[i][2])
        weights[j] += data.w[i][1]

        break
      end
    end
  end

  return solution, boxes, weights
end

function certificate(data, boxes)
  for i in 1:data.n
    if length(boxes[i]) == 0
      continue
    end

    # print("CAIXA $(i): ")

    for j in boxes[i]
      print("$(j)\t")
    end

    println()
  end
end

function main()
  file = open(ARGS[1], "r")
  data = read_input(file)

  solution, boxes, _ = sorted_greedy(data)

  println("TP2 2021421869 = $(solution)")
  certificate(data, boxes)
end

main()
