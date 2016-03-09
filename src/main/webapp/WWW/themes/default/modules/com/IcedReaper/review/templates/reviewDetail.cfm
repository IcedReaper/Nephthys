<cfoutput>
<article class="com-IcedReaper-review">
    <header>
        <h4>#attributes.review.getDescription()#</h4>
        <h1>#attributes.review.getHeadline()#</h1>
        <strong>#attributes.review.getIntroduction()#</strong>
    </header>
    <section>
        <cfif attributes.review.getImagePath() NEQ "">
            <figure>
                <img src="#attributes.review.getImagePath()#" alt="#attributes.review.getHeadline()#">
            </figure>
        </cfif>
        #attributes.review.getReviewText()#
    </section>
    <footer>
        Über den Author: #attributes.review.getCreator().getUserName()#
    </footer>
</div>
</cfoutput>