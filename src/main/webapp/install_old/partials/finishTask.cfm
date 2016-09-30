<script type="text/javascript">
    $(function() {
        $("#progressTasks li").last().find("i.fa").removeClass("fa-spinner").addClass("<cfif attributes.successful>fa-check-circle text-success<cfelse>fa-exclamation-circle text-danger</cfif>");
    });
</script>