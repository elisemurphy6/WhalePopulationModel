using Plots 
α = 1e-8 
X0 = [150000.0, 400000.0] 
 
function G(X)  
    B = X[1] 
    F = X[2] 
    
    return [ 
    0.05*B*(1 - B/150000) - α*B*F 
    0.08*F*(1 - F/400000) - α*B*F 
    ] 
end  
 
for h in 33.0:37.0 
    Xn = copy(X0) 
    Xs = [copy(X0)] 
 
    for n in 1:1000 
        Xn = Xn + h*G(Xn) 
        push!(Xs, copy(Xn)) 
    end  
 
    blue_whales = [X[1] for X in Xs] 
    fin_whales = [X[2] for X in Xs] 
 
    scatter( 
        blue_whales[101:end], 
        fin_whales[101:end],  
        xlabel ="Blue Whales",  
        ylabel = "Fin Whales", 
        title = "Limit set for h = $h", 
        label = false,  
        markersize = 2 
        ) 
 
    display(current()) 
end 
