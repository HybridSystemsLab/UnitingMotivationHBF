%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: HeavyBall.m
%--------------------------------------------------------------------------
% Project: Testing out parameters lambda and gamma for fast, oscillatory
% convergence globally and slow, smooth convergence locally.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%   See also HYEQSOLVER, PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC,
%   PLOTHARCCOLOR, PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 05/20/2015 3:42:00

clear all
set(0,'defaultTextInterpreter','latex'); %trying to set the default

% global variables
global gamma lambda lambda_0 lambda_1 gamma_0 gamma_1 c_0 c_10
%%%%%%%%%%%%%%%%%%%%%
% setting the globals
%%%%%%%%%%%%%%%%%%%%%

% Heavy-ball constants: Need to play around with these!
lambda = 15;%7.5; % Gravity. 
            % For gamma fixed, "large values of  lambda are seen to give rise to slowly converging 
            % solutions resembling the steepest descent’s while smaller values give 
            % rise to fast solutions with oscillations getting wilder as lambda decreases."
gamma = 1/2; % Viscous friction to mass ratio.

lambda_0 = 15;%7.5;
lambda_1 = 0.2;

gamma_0 = gamma;
gamma_1 = gamma;

c_0 = 12.5; % \mathcal{U}_0
c_10 = 6.22;%6.39; % \mathcal{T}_{1,0}

% initial conditions
z1_0 = -10;
z2_0 = 0;
q_0 = 0;

% Assign initial conditions to vector
x0 = [z1_0;z2_0;q_0];

% simulation horizon
TSPAN=[0 300];
JSPAN = [0 10];

% rule for jumps
% rule = 1 -> priority for jumps
% rule = 2 -> priority for flows
rule = 1;

options = odeset('RelTol',1e-6,'MaxStep',.1);

% simulate slow controller
[tSlow,jSlow,xSlow] = HyEQsolver(@f,@g,@C,@D,...
    x0,TSPAN,JSPAN,rule,options);

% Change value of lambda, for next simulation.
lambda = lambda_1;

% simulate fast, oscillatory controller
[t,j,x] = HyEQsolver(@f,@g,@C,@D,...
    x0,TSPAN,JSPAN,rule,options);

% simulate uniting
[tUniting,jUniting,xUniting] = HyEQsolver(@f1,@g1,@C1,@D1,...
    x0,TSPAN,JSPAN,rule,options);

% plot solution
figure(2) % position
clf
modificatorF{1} = '';
modificatorF{2} = 'LineWidth';
modificatorF{3} = 1.5;
modificatorJ{1} = '*--';
modificatorJ{2} = 'LineWidth';
modificatorJ{3} = 1.5;
subplot(3,1,1), plotHarc(tSlow,jSlow,xSlow(:,1),[],modificatorF);
grid on
axis([0 70 -10 10])
ylabel('$\mathrm{z_1}$','FontSize',16)
% pos1 = [0.7 0.72 0.1 0.1]
axes('Position',[0.7 0.73 0.15 0.08])
box on
plot(tSlow,xSlow(:,1),'LineWidth',1.5)
set(gca,'xtick',[0 150 300])
set(gca,'ytick',[-10 1])
axis([0 300 -10 1])
subplot(3,1,2), plotHarc(t,j,x(:,1),[],modificatorF);
grid on
ylabel('$\mathrm{z_1}$','FontSize',16)
axis([0 70 -10 10])
subplot(3,1,3), plotHarc(tUniting,jUniting,xUniting(:,1),[],modificatorF);
grid on
ylabel('$\mathrm{z_1}$','FontSize',16)
xlabel('$\mathrm{t}$','FontSize',16)
axis([0 70 -10 10])
saveas(gcf,'Plots\PlotsFastSlow','epsc')