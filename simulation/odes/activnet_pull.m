function activnet_pull(N,tt,z0,zet,L,mu,kap,del,nu,psi,sig,D,Df,ncnt,lf,r,tinc,ext,fileID)
    options = odeset('Mass',@activnet_mass_sp,'AbsTol',0.001,'RelTol',0.001);

    ind = 2;
    istep = length(tt)-1;
    if(r>0)
        istep = 2;
    end
    while(ind<length(tt))
        % solve for one timestep
        [~,z] = ode15s(@activnet_pull_ode,tt(ind-1:ind-1+istep),z0,options,zet,L,mu,kap,del,nu,psi,sig,D,Df,ncnt,lf,ext);

        % output to file
        for is=1:size(z,1)-1
            fprintf(fileID,'%.3f',tt(ind-1+is));
            for i=1:size(z,2)
                fprintf(fileID,' %.4f',z(is+1,i));
            end
            fprintf(fileID,'\n');
        end
        
        % setup for next iteration
        z0 = z(end,:);
        if(r>0)
            p = reshape(z0,[],2);
            p = [mod(p(:,1),2*D),mod(p(:,2),D)];

            i = randi(N,floor(r*2*tinc*N)+(rand<mod(r*2*tinc*N,1)),1);
            p((i-1)*ncnt+1,:) = D*[2*rand(size(i)) rand(size(i))];
            thet = rand(size(i))*2*pi;
            for j = 2:ncnt
                p((i-1)*ncnt+j,:) = p((i-1)*ncnt+j-1,:)+L/(ncnt-1.0)*[cos(thet) sin(thet)];
            end
            z0 = reshape(p,1,[]);
        end

        ind = ind+istep;
    end
end