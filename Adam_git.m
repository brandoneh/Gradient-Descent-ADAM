% This algorithm utilises Adaptive Moment Estimation (ADAM) to find a
% local minimum of the landscape from a randomised starting point

function Adam                   % Initialisation

DrawComplexLandscape;

NumSteps=10;                   % Number of steps for gradient descent
LRate=0.2;                      % Learning rate


StartPt = ((rand(1,2) *10) -3);
StartPt = [2,-2]

GradDescent(StartPt,NumSteps,LRate);



function GradDescent(StartPt,NumSteps,LRate)     % Gradient descent
PauseFlag=1;
hold on;
update = [0,0];
decay1 = 0.9;                                    % Decay rate 1
decay2 = 0.99;                                   % Decay rate 2
gEx = 0;
gEy = 0;
gSquaredEx = 0;
gSquaredEy = 0;


for i = 1:NumSteps

    x = StartPt(1);
    y = StartPt(2);
    z = ComplexLandscape(x,y);
    plot3(x,y,z,'r*','MarkerSize',10);
    
    
    g = ComplexLandscapeGrad(x,y);              % Gradient at current point

    % Recursively decaying equations to decide next location
    
    gEx = decay1*gEx + (1-decay1)*g(1);
    gEy = decay1*gEy + (1-decay1)*g(2);
    
    gSquaredEx = decay2*gSquaredEx + (1-decay2)*(g(1)^2);
    gSquaredEy = decay2*gSquaredEy + (1-decay2)*(g(2)^2);
    

    
    BCgEx = gEx/(1-(decay1)^i);
    BCgEy = gEy/(1-(decay1)^i);
    
    BCgSquaredEx = gSquaredEx/(1-(decay2)^i);
    BCgSquaredEy = gSquaredEy/(1-(decay2)^i);
    
    
    update(1) = (LRate/(sqrt(BCgSquaredEx)+(10^-8)))*BCgEx;     % Update for x
    update(2) = (LRate/(sqrt(BCgSquaredEy)+(10^-8)))*BCgEy;     % Update for y
    
    StartPt = StartPt - update;
    StartPt = max([StartPt;-3 -3]);                             % Enforces boundary
    StartPt = min([StartPt;7 7]);

    if(PauseFlag)
       x=input('Press return to continue\nor 0 and return to stop pausing\n');
       if(x==0) PauseFlag=0; end;
    end
%               if -4.3 > z  
%     break
    
%     end

end
hold off




function DrawComplexLandscape               % Draws the landscape
f = ['4*(1-x)^2*exp(-(x^2) - (y+1)^2)' ... 
         '- 15*(x/5 - x^3 - y^5)*exp(-x^2-y^2)' ... 
         '- (1/3)*exp(-(x+1)^2 - y^2)' ...
        '-1*(2*(x-3)^7 -0.3*(y-4)^5+(y-3)^9)*exp(-(x-3)^2-(y-3)^2)'   ];

ezmesh(f,[-3,7])


function[f]=ComplexLandscape(x,y)           % returns the height at x, y
f=4*(1-x)^2*exp(-(x^2)-(y+1)^2) -15*(x/5 - x^3 - y^5)*exp(-x^2-y^2) -(1/3)*exp(-(x+1)^2 - y^2)-1*(2*(x-3)^7 -0.3*(y-4)^5+(y-3)^9)*exp(-(x-3)^2-(y-3)^2);


function[g]=ComplexLandscapeGrad(x,y)       % Returns the gradient of x, y
g(1)=-8*exp(-(x^2)-(y+1)^2)*((1-x)+x*(1-x)^2)-15*exp(-x^2-y^2)*((0.2-3*x^2) -2*x*(x/5 - x^3 - y^5)) +(2/3)*(x+1)*exp(-(x+1)^2 - y^2)-1*exp(-(x-3)^2-(y-3)^2)*(14*(x-3)^6-2*(x-3)*(2*(x-3)^7-0.3*(y-4)^5+(y-3)^9));
g(2)=-8*(y+1)*(1-x)^2*exp(-(x^2)-(y+1)^2) -15*exp(-x^2-y^2)*(-5*y^4 -2*y*(x/5 - x^3 - y^5)) +(2/3)*y*exp(-(x+1)^2 - y^2)-1*exp(-(x-3)^2-(y-3)^2)*((-1.5*(y-4)^4+9*(y-3)^8)-2*(y-3)*(2*(x-3)^7-0.3*(y-4)^5+(y-3)^9));