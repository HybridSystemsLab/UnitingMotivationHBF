function GradL = GradientL(z1)
global z1Star
z1Star = 0;

GradL = 2*0.5*(0.5*z1 - z1Star);
end