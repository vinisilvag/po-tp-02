mutable struct Packing
  n::Int
  w::Array{Float64}
  B::Int
end

function read_input(file)
  n = 0
  w = []

  for line in eachline(file)
    q = split(line, "\t")

    if q[1] == "n"
      n = parse(Int64, q[2])
      w = [0.0 for i = 1:n]
    elseif q[1] == "o"
      index = parse(Int64, q[2])
      w[index+1] = parse(Float64, q[3])
    end
  end

  return Packing(n, w, 20)
end

function certificate()
end

function main()
  file = open(ARGS[1], "r")
  data = read_input(file)

  println(data)

  # println("TP1 2021421869 = ", sol)
  # certificate()
end

main()
