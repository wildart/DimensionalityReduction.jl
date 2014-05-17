function diffusion_maps(X::Matrix, d::Int=2; t::Int=1, sigma::Float64=1.0)
    X = minmax_normalization(X)
    
    println("Compute Markov forward transition probability matrix with $(t) timesteps...")
    sumX = sum(X.^ 2, 1)
    K = exp(( sumX' .+ sumX .- 2*At_mul_B(X,X) ) ./ (2*sigma^2))
    
    p = sum(K, 1)'
    K ./= ((p * p') .^ t)
    p = sqrt(sum(K, 1))'
    K ./= (p * p')
    
    U, S, V = svd(K, thin=false)
    U ./= U[:,1]
    Y = U[:,2:(d+1)]
    
    return Diffmap(d, t, K, Y')
end