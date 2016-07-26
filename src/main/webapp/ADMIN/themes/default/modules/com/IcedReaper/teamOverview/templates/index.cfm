<script type="text/javascript" src="/themes/default/directive/nephthysLoadingBar/nephthysLoadingBar.js"></script>

<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/teamOverview/js/teamOverviewApp.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/teamOverview/js/service/teamOverviewService.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/teamOverview/js/controller/teamOverviewList.js"></script>

<nephthys-loading-bar></nephthys-loading-bar>
<div ng-Controller="teamOverviewCtrl">
    <h1>Teammitglieder</h1>
    
    <div class="row">
        <div class="col-sm-12">
            <div class="card card-block">
                <h3>Neues Teammitglied</h3>
                <div class="row form-group">
                    <label for="userId" class="col-md-3 col-sm-12 control-label">User zum Team hinzufügen</label>
                    <div class="col-md-6 col-sm-8">
                        <select class="form-control" name="userId" ng-model="newUserId"
                                ng-options="u.userId as u.userName for u in remainingUser">
                        </select>
                    </div>
                    <div class="col-md-3 col-sm-4">
                        <button class="btn btn-primary" ng-click="addUser()"><i class="fa fa-floppy"></i> User zum Team hinzufügen</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="row">
        <div class="col-sm-12">
            <table class="table table-inverse m-t-1">
                <thead>
                    <tr>
                        <th>User</th>
                        <th>Aktionen</th>
                    </tr>
                </thead>
                <tbody>
                    <tr ng-repeat="member in teamMember">
                        <td>{{member.userName}}</td>
                        <td>
                            <a class="btn btn-info" href="/com.Nephthys.userManager#/{{member.userId}}"><i class="fa fa-eye"></i></a>
                            <button class="btn btn-danger" ng-click="removeMember(member.memberId)"><i class="fa fa-trash"></i></button>
                            <button class="btn btn-primary" ng-click="sortUp(member.memberId)" ng-if="! $first"><i class="fa fa-arrow-up"></i></button>
                            <button class="btn btn-primary" ng-click="sortDown(member.memberId)" ng-if="! $last"><i class="fa fa-arrow-down"></i></button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>