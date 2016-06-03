<cfoutput>
<section>
    <h1>Suchergebnisse</h1>
    
    <p>Bei der Suche nach <span class="label label-primary">&ldquo;#HTMLEditFormat(attributes.searchStatement)#&rdquo;</span> wurde(n) insgesamt <span class="label label-success">#attributes.resultCount#</span> Ergebnisse gefunden.</p>
    
    <cfloop collection="#attributes.results#" item="module">
        <cfloop from="1" to="#attributes.results[module].len()#" index="result">
            <article>
                <div class="card m-t-1 p-a-1">
                    <div class="card-block">
                        <h4 class="card-title"><a href="#attributes.results[module][result].link#">#attributes.results[module][result].linkText#</a></h4>
                        <cfif attributes.results[module][result].excerpt NEQ "">
                            <p class="card-text">#attributes.results[module][result].excerpt#</p>
                        </cfif>
                    </div>
                </div>
            </article>
        </cfloop>
    </cfloop>
</section>
</cfoutput>