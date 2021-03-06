<?xml version="1.0" encoding="UTF-8"?>
<iso:schema    
    xmlns="http://purl.oclc.org/dsdl/schematron"  
    xmlns:iso="http://purl.oclc.org/dsdl/schematron" 
    xmlns:vml="http://varioml.org/xml/1.0"
    queryBinding='xslt2'
    schemaVersion='ISO19757-3'>                  
    <iso:title>ISO schematron validation rules for the Cafe Variome data submissions</iso:title>
    <iso:ns prefix='vml' uri='http://varioml.org/xml/1.0'/> 
    
    <!-- Cafe Variome constraints  -->            
    <iso:let name="V2" value="number(//vml:cafe_variome/@schema_version) ge 2.0" />
    
    <iso:pattern id="cafe_variome.submission.checks">
        
        <iso:rule context="vml:cafe_variome">                                  
            <iso:assert  
                test="vml:source">Source is missing</iso:assert>
<iso:report
        test="vml:source">Source ok</iso:report> 
            <iso:assert  
                test="vml:variant">Variant is missing</iso:assert>
<iso:report
        test="vml:variant">Variant ok</iso:report> 
        </iso:rule>

        <iso:rule context="vml:cafe_variome/vml:source">                                  
            <iso:assert 
                test="@id">Source identifier is missing</iso:assert>             
            <iso:assert 
                test="vml:name">Name of source is missing</iso:assert>
<iso:report
        test="vml:name">Name of source ok</iso:report>             
        </iso:rule>

        <!-- contact is optional, but if we have then either name or email should be present-->
        <iso:rule context="vml:cafe_variome/vml:source/vml:contact">                                  
            <iso:assert 
                test="vml:name or vml:email">Contact name or email is missing</iso:assert> 
            <iso:assert test="not(@role) or @role='curator' or @role='producer' or @role='submitter'">Role of contact is not recognized</iso:assert>
            <iso:report 
                test="vml:name or vml:email">Contact ok</iso:report> 
        </iso:rule>

        <iso:rule context="vml:cafe_variome/vml:source/vml:comment">       
        <iso:assert test="not(@term='wasDerivedFrom') or @source='opmv'" >'wasDefinedFrom' cannot exist without 'opmv' name space (source)</iso:assert> 
            <iso:assert test="not(@source='opmv') or @term='wasDerivedFrom'" >opmv (open provenance mode) must have at least one predicate defined (e.g. 'wasDerivedFrom')</iso:assert>  
            <iso:assert test="not(@source='opmv' and @term='wasDerivedFrom') or not(@uri) or @uri='http://purl.org/net/opmv/ns#wasDerivedFrom'" >URI of wasDerivedFrom predicate was wrong</iso:assert>  
            <iso:assert test="not(@source='opmv') or vml:db_xref">Database xref is misisng in provenace content (source/comment/@source='opmv') element)</iso:assert>
            
            <iso:assert test="not(@term='disclaimer') or @source='g2p'" >'disclaimer cannot exist without 'g2p' name space (source)</iso:assert>             
            <iso:assert test="not(@term='disclaimer') or vml:text" >'disclaimer cannot exist without text element </iso:assert> 
        </iso:rule>
        
    </iso:pattern>
    
    <iso:pattern id="cafe_variome.reporting_variant.checks" >
        
        <iso:rule context="vml:cafe_variome/vml:variant">

            <iso:assert 
                test="vml:gene">Gene sequence is missing</iso:assert>
<iso:report
        test="vml:gene">Gene sequence ok</iso:report> 
            
            <iso:assert 
                test="vml:ref_seq">Reference sequence is missing</iso:assert>
<iso:report
        test="vml:ref_seq">Reference sequence ok</iso:report> 
            
            <iso:assert 
                test="vml:name">Name is missing</iso:assert>
<iso:report
        test="vml:name">Name ok</iso:report> 
            <iso:assert 
                test="vml:sharing_policy">Sharing policy of variant is missing</iso:assert>
<iso:report
        test="vml:sharing_policy">Sharing policy of variant ok</iso:report> 
            
            <iso:assert test="not($V2) or vml:panel">Panel is missing. Need to identify observation target (individual or panel)</iso:assert>
            <iso:report
        test="not($V2) or vml:panel">Panel ok</iso:report> 
        </iso:rule>

        <iso:rule context="vml:seq_changes/vml:variant">
            <!-- here we do not need gene anymore  -->           
            <iso:assert 
                test="vml:ref_seq">Reference sequence is missing</iso:assert>
<iso:report
        test="vml:ref_seq">Reference sequence ok</iso:report> 
            
            <iso:assert 
                test="vml:name">Name is missing</iso:assert>
<iso:report
        test="vml:name">Name ok</iso:report> 
                       
        </iso:rule>
 
        <iso:rule context="vml:aliases/vml:variant">
            <!-- legacy variants. Only name is needed -->            
            <iso:assert 
                test="vml:name">Name is missing</iso:assert>
<iso:report
        test="vml:name">Name ok</iso:report> 
            
        </iso:rule>
        
        <iso:rule context="vml:variant/vml:name">
            <iso:assert test="not(@scheme) or upper-case(@scheme)='HGVS'">HGVS naming scheme should be used. Found: <iso:value-of select="@scheme"/> </iso:assert>
            <!-- Should use HGVS names only...
            <iso:assert test="starts-with(normalize-space(text()),'g.') or starts-with(normalize-space(text()),'c.') or starts-with(normalize-space(text()),'p.') or starts-with(normalize-space(text()),'r.')"></iso:assert>
            -->

            <iso:report test="not(@scheme) or upper-case(@scheme)='HGVS'">HGVS naming scheme correctly used: <iso:value-of select="@scheme"/> </iso:report>

<!-- 
            <iso:report test="starts-with(normalize-space(text()),'g.') or starts-with(normalize-space(text()),'c.') or starts-with(normalize-space(text()),'p.') or starts-with(normalize-space(text()),'r.')"></iso:report>
-->
        </iso:rule>
  
        <iso:rule context="vml:location">
            <iso:assert test="vml:ref_seq">Location must have reference sequence</iso:assert>
<!--
            <iso:assert test="not(vml:chr)">Location entry should not have chromosome. Chromosome reference sequence should be used instead</iso:assert>
-->
            <iso:assert test="normalize-space(vml:end) ge normalize-space(vml:start) ">Incorrect location. End should be larger or equal than start position</iso:assert>



            <iso:report test="vml:ref_seq">Location has reference sequence</iso:report>
            <iso:report test="not(vml:chr)">Location entry has Chromosome reference sequence</iso:report>
            <iso:report test="normalize-space(vml:end) ge normalize-space(vml:start) ">Location End is correctly larger or equal to start position</iso:report>


        </iso:rule>
        
        <iso:rule context="vml:sharing_policy">
            <iso:assert test="@type='openAccess' or @type='closedAccess' or @type='embargoedAccess' or @type='restrictedAccess'">
                Sharing policy should be either: 'closedAccess' or 'embargoedAccess' or 'restrictedAccess' or 'openAccess'
            </iso:assert>
            <iso:assert test="not(@type='embargoedAccess') or exists(child::vml:embargo_end_date)">
                Embargo end date is mandatory if sharing policy is set to embargoed 
            </iso:assert>
            <iso:report test="@type='openAccess' or @type='closedAccess' or @type='embargoedAccess' or @type='restrictedAccess'">
                Sharing policy matches accepted terms ( 'closedAccess' or 'embargoedAccess' or 'restrictedAccess' or 'openAccess')
            </iso:report>
            <iso:report test="not(@type='embargoedAccess') or exists(child::vml:embargo_end_date)">
                Sharing policy is set to embargoed; required Embargo end date is present.  
            </iso:report>
        </iso:rule>

        <iso:rule context="vml:variant/vml:panel" >
            <iso:assert test="(count(vml:phenotype)+count(vml:individual)+count(vml:organism)+count(vml:population)+count(vml:comment)) = count(child::*)" >This element contains VarioML terms which are not part of the Cafe Variome spec</iso:assert>
            <iso:assert test="not($V2) or @id"></iso:assert>
        </iso:rule>
        
        <iso:rule context="vml:variant/vml:panel/vml:individual" >

            <iso:assert test="(count(vml:gender)) = count(child::*)" >Element panel/individual contains VarioML terms which are not part of the Cafe Variome spec</iso:assert>
        </iso:rule>
        
  
        <iso:rule context="vml:variant/vml:variant_detection" >
            <iso:assert test="@technique" >Technique missing in variant detection</iso:assert>
            <iso:assert test="@template" >Template missing in variant detection</iso:assert>
            <iso:report test="@technique" >Variant detection has Technique element</iso:report>
            <iso:report test="@template" >Variant detection has Template element</iso:report>
        </iso:rule>

        <iso:rule context="vml:variant/vml:frequency" >
          
        </iso:rule>
        
    </iso:pattern>

    <iso:pattern id="cafe_variome.xrefs" >
        
        <iso:rule context="vml:db_xref" >
            <iso:assert test="@accession or @uri" >Accession number or URI is missing in database xref (gene or ref_seq)</iso:assert>
        <iso:report test="@accession or @uri" >Database xref ok</iso:report>
        </iso:rule>

        <iso:rule context="vml:gene" >
            <iso:assert test="@accession or @uri" >Accession number is missing in database xref (gene or ref_seq)</iso:assert>
            <iso:assert test="not($V2)  or upper-case(@source)='HGNC.SYMBOL' or upper-case(@source)='HGNC'" >Source of gene should be HGNC_Symbol or HGNC</iso:assert> 

            <iso:report test="@accession or @uri" >Database xref (gene or ref_seq) contains required accession number.</iso:report>
            <iso:report test="not($V2)  or upper-case(@source)='HGNC.SYMBOL' or upper-case(@source)='HGNC'" >Source of gene is HGNC_Symbol or HGNC</iso:report>            
        </iso:rule>
        
        <iso:rule context="vml:ref_seq" >
            <iso:assert test="@accession" >Accession number is missing in database xref (gene or ref_seq)</iso:assert>
            <iso:assert test="not($V2) or upper-case(@source)='GENBANK' or upper-case(@source)='REFSEQ' or upper-case(@source)='ENSEMBL' or upper-case(@source)='UCSC'" >Source of ref sequence is wrong</iso:assert>            
            <iso:report test="@accession" >Database xref (gene or ref_seq) contains required accession number.</iso:report>
            <iso:report test="not($V2) or upper-case(@source)='GENBANK' or upper-case(@source)='REFSEQ' or upper-case(@source)='ENSEMBL' or upper-case(@source)='UCSC'" >Ref sequence Source is correctly formatted.</iso:report>  
        </iso:rule>
        
    </iso:pattern>
    
    <iso:pattern id="cafe_variome.ontology_terms" >

        <iso:rule context="vml:genetic_origin|vml:pathogenicity|vml:phenotype|vml:evidence_code|vml:use_permission|vml:variant_type|vml:consequence" >
            <iso:assert test="@term" >Ontology term (genetic_origin, pathogenicity..) should have term-attribute </iso:assert>
            <iso:report test="@term" >Ontology term ok. Ontology term (genetic_origin, pathogenicity..) should always have term-attribute </iso:report>

        </iso:rule>
        
    </iso:pattern>
    

    <iso:pattern id="cafe_variome.misc" >

        <iso:rule context="vml:comment" >
            <iso:assert test="vml:text or @term" >Comment element should have text (preferred) or term</iso:assert>
            <iso:report test="vml:text or @term" >Comment element ok.Comment element should have text (preferred) or term.</iso:report>
        </iso:rule>
        
    </iso:pattern>
    
</iso:schema>
