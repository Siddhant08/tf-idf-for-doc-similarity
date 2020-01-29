function dist_matrix = docdistances()
    %function to calculate distance(difference) between two documents
    
    %read documents in lowercase
    tr1=lower(textread('RedRidingHood.txt','%s'));
    tr2=lower(textread('PrincessPea.txt','%s'));
    tr3=lower(textread('Cinderella.txt','%s'));
    tr4=lower(textread('CAFA1.txt','%s'));
    tr5=lower(textread('CAFA2.txt','%s'));
    tr6=lower(textread('CAFA3.txt','%s'));
    
    %combine all words of corpus into one cell array
    words_all=vertcat(tr1,tr2,tr3,tr4,tr5,tr6);
    
    %total docs in corpus
    n_docs=6;
    
    %calculate term frequency
    function term_freq = tf_func(tr)
        %function to calculate term frequency
        
        %get frequency
        unique_words = unique(words_all);
        %freq=histc(J,1:numel(unique_words));
        freq=zeros(1,numel(unique_words));
        for i=1:numel(unique_words)
            match=regexp(tr,strcat(unique_words{i},'\>'));
            freq(i)=length(find([match{:}]==1));
        end
        %double array of frequency of unique words
        term_freq = (freq');
    end

    function inv_doc_freq = idf()
        %compute inverse document frequency for every term
        
        %get unique words in doc
        unique_words=unique(words_all);
        %store number of docs where term occurrs
        doc_t=zeros(1,numel(unique_words));
        %iterate through each unique word in doc to get idf vector
        for i=1:length(unique_words)
            ctr=0;
            match=regexp(tr1,strcat(unique_words{i},'\>'));
            if ~isempty(find([match{:}]>=1, 1))
                ctr=ctr+1;
            end
            match=regexp(tr2,strcat(unique_words{i},'\>'));
            if ~isempty(find([match{:}]>=1, 1))
                ctr=ctr+1;
            end
            match=regexp(tr3,strcat(unique_words{i},'\>'));
            if ~isempty(find([match{:}]>=1, 1))
                ctr=ctr+1;
            end
            match=regexp(tr4,strcat(unique_words{i},'\>'));
            if ~isempty(find([match{:}]>=1, 1))
                ctr=ctr+1;
            end
            match=regexp(tr5,strcat(unique_words{i},'\>'));
            if ~isempty(find([match{:}]>=1, 1))
                ctr=ctr+1;
            end
            match=regexp(tr6,strcat(unique_words{i},'\>'));
            if ~isempty(find([match{:}]>=1, 1))
                ctr=ctr+1;
            end
            doc_t(i)=ctr;
        end
        
        %get idf vector
        inv_doc_freq=log10(n_docs./doc_t);
    end
    
    %calculate tf vectors for all docs
    tf_cinde=tf_func(tr1);
    tf_ppea=tf_func(tr2);
    tf_rrh=tf_func(tr3);
    tf_c1=tf_func(tr4);
    tf_c2=tf_func(tr5);
    tf_c3=tf_func(tr6);
    
    %calculate idf vector
    idf_vec=idf();
    %calculate tf-idf vector for all docs
    tfidf_cinde=tf_cinde.*idf_vec';   tfidf_ppea=tf_ppea.*idf_vec';   tfidf_rrh=tf_rrh.*idf_vec';
    tfidf_c1=tf_c1.*idf_vec'; tfidf_c2=tf_c2.*idf_vec'; tfidf_c3=tf_c3.*idf_vec';
        
    %compute cosine distance
    vec_list=[tfidf_cinde,tfidf_ppea,tfidf_rrh,tfidf_c1,tfidf_c2,tfidf_c3];
    %d = 1 - dot(v1,v2)/(norm(v1)*norm(v2));   %formula for cosine distance
    dist_matrix=zeros(n_docs,n_docs);
    for i=1:n_docs
        for j=1:n_docs
            dist_matrix(i,j)= 1 - dot(vec_list(:,i),vec_list(:,j))/(norm(vec_list(:,i))*norm(vec_list(:,j)));
        end
    end
    
    %plot distance matrix
    labels={'RRH','PPea','Cinde','CAFA1','CAFA2','CAFA3'};
    plt=imagesc(dist_matrix);
    colormap(gray)
    title('Cosine Distance')
    colorbar;
    set(gca,'xtick',[1:6],'xticklabel',labels);
    set(gca,'ytick',[1:6],'yticklabel',labels);
end        
