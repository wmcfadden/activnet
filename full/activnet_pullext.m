function activnet_pullext(N,tt,z0,zet,L,mu,kap,del,nu,psi,sig,D,Df,ncnt,lf,r,tinc,fileID)
    options = odeset('Mass',@sp_activnet_mass,'AbsTol',0.01,'RelTol',0.01);

    ind = 2;
    istep = length(tt)-1;
    while(ind<length(tt))
        % solve for one timestep
        [~,z] = ode15s(@activnet_ode_pullext,tt(ind-1:ind-1+istep),z0,options,zet,L,mu,kap,del,nu,psi,sig,D,Df,ncnt,lf);

        % output to file
        for is=2:istep
            fprintf(fileID,'%.3f',tt(ind-1+is));
            for i=1:size(z,2)
                fprintf(fileID,' %.4f',z(is,i));
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
                p((i-1)*ncnt+j,:) = p((i-1)*ncnt+j-1,:)+L/(ncnt-1.0)*repmat([cos(thet) sin(thet)],length(i),1);
            end
            z0 = reshape(p,1,[]);
        end

        ind = ind+istep;
    end
end