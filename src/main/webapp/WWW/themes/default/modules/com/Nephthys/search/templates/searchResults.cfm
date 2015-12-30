<cfoutput>
<section>
    <h1>Suchergebnisse</h1>
    
    <p>Bei der Suche nach &ldquo;#HTMLEditFormat(attributes.searchStatement)#&rdquo; wurde(n) insgesamt <span class="label label-success">#attributes.resultCount#</span> Ergebnisse gefunden.</p>
    
    <cfloop collection=#attributes.results# item="module">
        <cfloop from="1" to="#attributes.results[module].len()#" index="result">
            <article>
                <div class="card m-t p-a">
                    <a href="#attributes.results[module][result].link#">#attributes.results[module][result].excerpt#</a>
                </div>
            </article>
        </cfloop>
    </cfloop>
</section>
</cfoutput>