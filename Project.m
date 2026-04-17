Fs = input('Enter sampling frequency (Fs): ');
t_s = input('Enter start time: ');
t_e = input('Enter end time: ');

n_bp = input('Enter number of break points: ');
while (n_bp < 0)
    n_bp = input('Invalid number of breakpoint, Enter number of breakpoints again: ');
end

bp = zeros(1,n_bp);
for i = 1:n_bp
    bp(i) = input(sprintf('Enter position of break point %d: ',i));
    while (bp(i) < t_s || bp(i) > t_e)
        bp(i) = input(sprintf('Invalid position entered (Not within time range %d to %d), Enter position again: ',t_s,t_e));
    end
end
bp = sort(bp);

signal = [];
time = [];


for j = 1:(n_bp+1)
    valid = 0;
    while valid == 0
        def = input('Enter the signal type (e.g. dc, ramp, polynomial, exponential, sin): ','s');
        switch(def)
            case 'dc'
                A = input('Enter the amplitude of the DC signal: ');
                td = TimeRange(t_s,t_e,Fs,n_bp,bp,j);
                if (j < (n_bp+1))
                    td = td(1:end-1);
                end
                DC = A*ones(1,length(td));
                signal = [signal DC];
                time = [time td];
                valid = 1;
            
            case 'ramp'
                s = input('Enter the slope of the signal: ');
                c = input('Enter the intercept of the signal: ');
                tr = TimeRange(t_s,t_e,Fs,n_bp,bp,j);
                if (j < (n_bp+1))
                    tr = tr(1:end-1);
                end
                Ramp = s*tr + c;
                signal = [signal Ramp];
                time = [time tr];
                valid = 1;
              
            case 'sin'
                a = input('Enter the amplitude of sinusoidal signal: ');
                fo = input('Enter the frequency of the sinusoidal signal: ');
                p = input('Enter the phase shift of the sinusoidal signal: ');
                ts = TimeRange(t_s,t_e,Fs,n_bp,bp,j);
                if (j < (n_bp+1))
                    ts = ts(1:end-1);
                end
                Sinusoidal = a*sin(2*pi*fo*ts + p);
                signal = [signal Sinusoidal];
                time = [time ts];
                valid = 1;
        
            case 'polynomial'
                m = input('Enter the amplitude of the polynomial signal: ');
                w = input('Enter the power of the polynomial signal: ');
                n = input('Enter the intercept of the polynomial signal: ');
                tp = TimeRange(t_s,t_e,Fs,n_bp,bp,j);
                if (j < (n_bp+1))
                    tp = tp(1:end-1);
                end
                polynomial = m*tp.^w + n ;
                signal = [signal polynomial];
                time = [time tp];
                valid = 1;
           
            case 'exponential'
                u = input('Enter the amplitude of the exponential signal: ');
                k = input('enter the exponent of the exponential signal: ');
                te = TimeRange(t_s,t_e,Fs,n_bp,bp,j);
                if (j < (n_bp+1))
                    te = te(1:end-1);
                end
                exponential = u * exp(k*te);
                signal = [signal exponential];
                time = [time te];
                valid = 1;

            otherwise
                disp('Invalid signal type. Please try again.');
        end
    end
end

figure;
plot(time, signal);
xlabel('Time (sec)');
ylabel('Amplitude');
title('Generated Signal');
grid on;


    
choice = 1;

while choice == 1

    op = input('Enter the operation you want ( 1:amplitude scaling , 2:time reversal , 3:time shift , 4:expanding , 5:compressing , 6:none ):');
    switch (op)

        case (1)
            scale = input('Enter scaling value: ');
            signal = signal * scale ;    

        case (2)
            signal = signal(end:-1:1);
            time = -time(end:-1:1);
      
        case (3)
            shift =input('Enter shift value: ');
            time = time + shift;

        case 4
            factor = input('Enter expanding factor (>1): ');
            while factor <= 1
                factor = input('Invalid factor entered (needs to be >1). Enter the factor again: ');
            end
            time = time * factor;

        case 5
            factor = input('Enter compressing factor (>1): ');
            while factor <= 1
                factor = input('Invalid factor entered (needs to be >1). Enter the factor again: ');
            end
            time = time / factor;

        case 6
            break;

        otherwise
            disp('Invalid operation');
    end

    figure;
    plot(time, signal);
    xlabel('Time (sec)');
    ylabel('Amplitude');
    title('Updated Signal');
    grid on;

    choice = input('Do you want another operation? (1=yes, 0=no): ');
end

function t = TimeRange(t_s,t_e,Fs,n_bp,bp,j)
    if (n_bp == 0)
        t = linspace(t_s,t_e,(t_e - t_s)*Fs);
    elseif (j == 1)
        t = linspace(t_s,bp(1),(bp(1)-t_s)*Fs);
    elseif(j <= n_bp)
        t = linspace(bp(j-1),bp(j),(bp(j)-bp(j-1))*Fs);
    else
        t = linspace(bp(end),t_e,(t_e-bp(end))*Fs);
    end
end