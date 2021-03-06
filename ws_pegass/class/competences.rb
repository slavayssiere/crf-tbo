require_relative './pegass'
require 'json'
require 'sinatra/logger'

class CompetencesClass

    attr_accessor :pegass
    attr_accessor :logger
    
    def initialize(pegassConnection, log)
        @pegass = pegassConnection
        @logger = log
    end    
    
    def listStructureWithCompetence(competence, ul, page)
        benevoles = @pegass.callUrl('/crf/rest/utilisateur?page='+page+'&pageInfo=true&perPage=10&structure='+ul)

        competence_ul = {}
        competence_ul['list']=[]
        benevoles['list'].each do | benevole |
            # {"id"=>"nivol", "structure"=>{"id"=>899}, "nom"=>"name", "prenom"=>"first", "actif"=>true}
        
            ret = benevoleWithCompetence(benevole['id'], competence)
                        
            if ret==true
                comp_bene = {}
                comp_bene['nivol']=benevole['id']
                comp_bene['prenom']=benevole['prenom']
                comp_bene['nom']=benevole['nom']
                competence_ul['list'].push comp_bene                
            end
                        
        end
        
        
        competence_ul['last_page']=page
        competence_ul['pages']=benevoles['pages']
        return competence_ul
    end    

    def listStructureTC(ul, page)
        benevoles = @pegass.callUrl('/crf/rest/utilisateur?page='+page+'&pageInfo=true&perPage=10&structure='+ul)

        competence_ul = {}
        competence_ul['list']=[]
        benevoles['list'].each do | benevole |
            # {"id"=>"nivol", "structure"=>{"id"=>899}, "nom"=>"name", "prenom"=>"first", "actif"=>true}
        
            retPSC = benevoleWithCompetence(benevole['id'], "PSC1 IRR") # PSC1 - 276
            retCRB = benevoleWithCompetence(benevole['id'], "CRB") # CRB - 302
            retTCAU = benevoleWithCompetence(benevole['id'], "TCAU") # TCAU - 282
            retTCAS = benevoleWithCompetence(benevole['id'], "TCAS") # TCAS - 401
                        
            comp_bene = {}
            comp_bene['nivol']=benevole['id']
            comp_bene['prenom']=benevole['prenom']
            comp_bene['nom']=benevole['nom']
            comp_bene['PSC']=retPSC
            comp_bene['CRB']=retCRB
            comp_bene['TCAU']=retTCAU
            comp_bene['TCAS']=retTCAS

            competence_ul['list'].push comp_bene   
                        
        end
        
        competence_ul['last_page']=page
        competence_ul['pages']=benevoles['pages']
        return competence_ul
    end

    def listStructureWithCompetenceId(competenceid, type, ul, page)
        searchstring = "formation"
        if type.eql? "COMP"
            searchstring = "role"
        elsif type.eql? "NOMI"
            searchstring = "nomination"
        end 
        benevoles = @pegass.callUrl('/crf/rest/utilisateur?'+searchstring+'='+competenceid+'&page='+page+'&pageInfo=true&perPage=10&structure='+ul)
        puts '/crf/rest/utilisateur?'+searchstring+'='+competenceid+'&page='+page+'&pageInfo=true&perPage=10&structure='+ul
        competence_ul = {}
        competence_ul['list']=[]
        if benevoles['list'] != nil 
            benevoles['list'].each do | benevole |
                # {id: "00000023206Z", structure: {id: 899}, nom: "ADRIEN", prenom: "Alain", actif: true}
            
                comp_bene = {}
                comp_bene['nivol']=benevole['id']
                comp_bene['prenom']=benevole['prenom']
                comp_bene['nom']=benevole['nom']
                competence_ul['list'].push comp_bene    
            end
        end
        
        competence_ul['last_page']=page
        competence_ul['pages']=benevoles['pages']
        return competence_ul
    end       
    
    def listStructureWithoutCompetence(competenceid, type, ul, page)
        searchstring = "formation"
        if type.eql? "COMP"
            searchstring = "role"
        elsif type.eql? "NOMI"
            searchstring = "nomination"
        end 
        benevoles = @pegass.callUrl('/crf/rest/utilisateur?page='+page+'&page=0&pageInfo=true&perPage=10&structure='+ul)

        competence_ul = {}
        competence_ul['list']=[]
        benevoles['list'].each do | benevole |
            # {"id"=>"nivol", "structure"=>{"id"=>899}, "nom"=>"name", "prenom"=>"first", "actif"=>true}
        
            ret = benevoleWithoutCompetence(benevole['id'], competenceid, type)
            if ret==true
                comp_bene = {}
                comp_bene['nivol']=benevole['id']
                comp_bene['prenom']=benevole['prenom']
                comp_bene['nom']=benevole['nom']
                competence_ul['list'].push comp_bene               
            end
                        
        end
        
        
        competence_ul['last_page']=page
        competence_ul['pages']=benevoles['pages']
        return competence_ul
    end
    
    def listStructureComplexe(competence, nocompetence, ul, page)
        benevoles = @pegass.callUrl('/crf/rest/utilisateur?page='+page+'&page=0&pageInfo=true&perPage=10&structure='+ul)

        competence_ul = {}
        competence_ul['list']=[]
        benevoles['list'].each do | benevole |
            # {"id"=>"nivol", "structure"=>{"id"=>899}, "nom"=>"name", "prenom"=>"first", "actif"=>true}
        
            ret = benevoleComplexe(benevole['id'], competence, nocompetence)
            
            # # logger.info "#{benevole['nom']}, #{competence} (yes) #{nocompetence} (no): #{ret}"
            if ret==true
                comp_bene = {}
                comp_bene['nivol']=benevole['id']
                comp_bene['prenom']=benevole['prenom']
                comp_bene['nom']=benevole['nom']
                competence_ul['list'].push comp_bene             
            end
                        
        end
        
        
        competence_ul['last_page']=page
        competence_ul['pages']=benevoles['pages']
        return competence_ul
    end
    
    def benevoleComplexe(nivol, competence, nocompetence)
        retCompetence = false
        retNoCompetence = true
                         
        formations = pegass.callUrl("/crf/rest/formationutilisateur?utilisateur=#{nivol}")
        
        formations.each do | formation |
            if formation['formation']['code']==competence
                retCompetence = true
            end
            if formation['formation']['code']==nocompetence
                retNoCompetence = false
            end
        end
        
        ret = retCompetence && retNoCompetence
        
        return ret
    end

    def benevoleWithCompetence(nivol, competence)
        ret = false
        endOfYear = Date.parse("#{Date.today.year}-12-31")
        
        formations = pegass.callUrl("/crf/rest/formationutilisateur?utilisateur=#{nivol}")
        formations.each do | formation |
            if formation['formation']['code']==competence
                if(formation['dateRecyclage'])
                    dateRecyclage = Date.parse formation['dateRecyclage']
                    avantRecyclage = endOfYear - dateRecyclage
                    
                    # # logger.info "#{formation['dateRecyclage']} vs #{endOfYear} = #{avantRecyclage}"
                    
                    if(avantRecyclage <= 0)
                        ret = true
                    end
                else
                    ret = true
                end                
                break
            end
        end        
        
        return ret
    end

    def benevoleWithoutCompetence(nivol, competenceid, type)
        ret = true
           
        formations = pegass.callUrl("/crf/rest/formationutilisateur?utilisateur=#{nivol}")
        
        formations.each do | formation |
            if formation['formation']['id']==competenceid
                ret = false
            end
        end    
        
        return ret
    end

    def listCompetences()
       ret = {}
       ret['competences']=[]
       ret['nominations']=[]
       ret['formations']=[]
       comps = @pegass.callUrl("/crf/rest/roles")
       comps.each do |comp|
           begin
                block = {}
                block['id']=comp['id']
                block['libelle']=comp['libelle']
                if comp['type'].eql? "COMP"
                    ret['competences'].push block
                elsif comp['type'].eql? "NOMI"
                    ret['nominations'].push block
                elsif comp['type'].eql? "FORM"
                    ret['formations'].push block
                end
            rescue => exception
                @logger.info exception
            end
       end
       
       return ret
    end
    
    def getCompetences()
       ret = {}
       ret['list']=[]
       comps = @pegass.callUrl("/crf/rest/roles")
       comps.each do |comp|
           if(comp['type'].eql? "COMP" or comp['type'].eql? "FORM")
               block = {}
               block['id']=comp['id']
               block['libelle']=comp['libelle']
               ret['list'].push block
           end
       end
       
       return ret
    end

    def get_id_formation(competence_search)
        competences = @pegass.callUrl('/crf/rest/roles')
        cid = 0 
        type = ""
        competences.each do |competence|
            begin
                if competence['libelle'] =~ /^#{competence_search}\s+[a-zA-Z0-9() ]*/
                    cid = competence['id']
                    type = competence['type']
                    puts "case1: #{competence['libelle']}"
                    break
                elsif competence['libelle'] =~ /^#{competence_search}/
                    cid = competence['id']
                    type = competence['type']
                    puts "case2: #{competence['libelle']}"
                end
            rescue => exception
                @logger.error exception
            end
        end
        return cid, type
    end
end