## Given  
dB = 0.05*B*(1 - B/150000) - α*B*F 
dF = 0.08*F*(1 - F/400000) - α*B*F 
## Part i  
using Plots 
α = 1e-8 
h = 32.0  
X0 = [5000.0, 70000.0] 
 
function G(X)  
    B = X[1] 
    F = X[2] 
    
    return [ 
    0.05*B*(1 - B/150000) - α*B*F 
    0.08*F*(1 - F/400000) - α*B*F 
    ] 
end  
 
Xn = copy(X0) 
Xs = [copy(X0)] 
 
for n in 1:50 
    Xn = Xn + h*G(Xn) 
    push!(Xs, copy(Xn)) 
end  
 
times = h .* (0:50) 
fin_whales = [X[2] for X in Xs] 
scatter(times, fin_whales, xlabel ="years", ylabel = "Fin whales", label = false) 
