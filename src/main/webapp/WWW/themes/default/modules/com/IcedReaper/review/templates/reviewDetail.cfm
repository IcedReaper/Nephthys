<cfoutput>
<article class="com-IcedReaper-review">
    <header>
        <p class="pull-right">
            <cfif attributes.review.getRating() EQ 0.5>
                <i class="fa fa-star-half-o"></i>
            <cfelseif  attributes.review.getRating() GTE 1>
                <i class="fa fa-star"></i>
            </cfif>
            <cfif attributes.review.getRating() EQ 1.5>
                <i class="fa fa-star-half-o"></i>
            <cfelseif  attributes.review.getRating() GTE 2>
                <i class="fa fa-star"></i>
            </cfif>
            <cfif attributes.review.getRating() EQ 2.5>
                <i class="fa fa-star-half-o"></i>
            <cfelseif  attributes.review.getRating() GTE 3>
                <i class="fa fa-star"></i>
            </cfif>
            <cfif attributes.review.getRating() EQ 3.5>
                <i class="fa fa-star-half-o"></i>
            <cfelseif  attributes.review.getRating() GTE 4>
                <i class="fa fa-star"></i>
            </cfif>
            <cfif attributes.review.getRating() EQ 4.5>
                <i class="fa fa-star-half-o"></i>
            <cfelseif  attributes.review.getRating() EQ 5>
                <i class="fa fa-star"></i>
            </cfif>
        </p>
        <h4>#attributes.review.getDescription()#</h4>
        <strong>#attributes.review.getIntroduction()#</strong>
        <h5><small>Diese Bewertung wurde am #application.system.settings.getValueOfKey("formatLibrary").formatDate(attributes.review.getCreationDate())# von <a href="/User/#attributes.review.getCreator().getUsername()#">#attributes.review.getCreator().getUsername()#</a> in der Kategorie <a href="#request.page.getLink()#/Kategorie/#attributes.review.getType().getName()#">#attributes.review.getType().getName()#</a> erstellt.</small></h5>
    </header>
    <section class="m-t-1">
        <h1>#attributes.review.getHeadline()#</h1>
        
        <cfif attributes.review.getImagePath() NEQ "">
            <figure>
                <img src="#attributes.review.getImagePath()#" alt="#attributes.review.getHeadline()#">
            </figure>
        </cfif>
        
        #attributes.review.getReviewText()#
    </section>
    <footer>
        <p>
            <strong>Genre:</strong>
            <cfset genre = attributes.review.getGenre()>
            <cfloop from="1" to="#genre.len()#" index="genreIndex">
                <a class="label label-primary" href="#request.page.getLink()#/Kategorie/#genre[genreIndex].getName()#">#genre[genreIndex].getName()#</a>
            </cfloop>
        </p>
        <p>
            Über den Author <a href="/User/#attributes.review.getCreator().getUsername()#">#attributes.review.getCreator().getUsername()#</a>
        </p>
    </footer>
</div>
</cfoutput>