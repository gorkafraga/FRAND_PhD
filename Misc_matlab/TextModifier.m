DIRINPUT = 'H:\Desktop';
DIROUTPUT = 'H:\Desktop'; 
filename = 'mysyntax'; 

cd (DIRINPUT)
% MODIFY TEXT SCRIPTS FOR SPSS
 mytext = char(textread('syntaxgraph.txt','%s', 'whitespace', '\b' ));
 mynewtext = mytext;
 subjs = [302:320];
 merged = [];
 for r = 1:length(subjs)
        for row = 1:size(mytext,1);
         myline = mytext(row,:); 
            [a b] = regexpi(myline,'subj');% "subj" in text will be replaced for subject code
            if ~isempty(a);
                if size(a,2) > 1 % if there is more than one match in the line loop through them
                    for l = 1:length(a)
                     myline(a(l)+1:b(l)) = num2str(subjs(r));% replace with new subj code
                     mynewtext(row,:) = myline;
                    end
                else % if there is only one match in the line
                    myline(a+1:b) = num2str(subjs(r));%replace with new subject code
                    mynewtext(row,:) = myline;
                end
            end
        end
merged = [merged;mynewtext];
 end
 
 cd (DIROUTPUT) 
 dlmwrite([filename,'.txt'],merged,'delimiter','','newline','pc')

 