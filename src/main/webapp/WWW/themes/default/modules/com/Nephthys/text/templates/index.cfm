<cfoutput>
    <article<cfif attributes.options.keyExists('centered') AND attributes.options.centered EQ true> class="text-xs-center"</cfif>>
        #attributes.options.content#
    </article>
</cfoutput>