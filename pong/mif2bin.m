function mif2bin(nome)

ain=fopen('snake.mif','r');
s=fscanf(ain,'%s');
aout=fopen('snake.bin','wb');
endian=0;

for i=1:length(s)
    if(s(i)==':')
        for k=1:8:640
            if(endian)
                s1=s(i+k:i+k+1);
                s2=s(i+k+2:i+k+3);
                s3=s(i+k+4:i+k+5);
                s4=s(i+k+6:i+k+7);
            else     
                s4=s(i+k:i+k+1);
                s3=s(i+k+2:i+k+3);
                s2=s(i+k+4:i+k+5);
                s1=s(i+k+6:i+k+7);
            end
            
            s4=hex2dec(s4); %str2num(converte_base5(s4,[16 0],[10 0]));
            c=fwrite(aout,s4,'uint8');
            s3=hex2dec(s3); %str2num(converte_base5(s3,[16 0],[10 0]));
            c=fwrite(aout,s3,'uint8');
            s2=hex2dec(s2); %str2num(converte_base5(s2,[16 0],[10 0]));
            c=fwrite(aout,s2,'uint8');
            s1=hex2dec(s1); %str2num(converte_base5(s1,[16 0],[10 0]));
            c=fwrite(aout,s1,'uint8');

        end
        i=i+640;
    end
end

fclose(ain);
fclose(aout);

end
