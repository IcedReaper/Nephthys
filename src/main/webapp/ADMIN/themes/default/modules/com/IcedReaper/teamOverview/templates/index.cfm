<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/teamOverview/js/teamOverviewApp.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/teamOverview/js/service/teamOverviewService.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/teamOverview/js/controller/teamOverviewList.js"></script>

<div ng-Controller="teamOverviewCtrl">
    <h1>Teammitglieder</h1>
    
    <h3>Neues Teammitglied</h3>
    
    <form>
        <fieldset class="form-group">
            <div class="row">
                <div class="col-sm-12">
                    <label for="userId" class="col-sm-3 control-label">User zum Team hinzufügen</label>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <select class="form-control" name="userId" ng-model="newUserId">
                        <option ng-repeat="user in remainingUser" value="{{user.userId}}">{{user.userName}}</option>
                    </select>
                </div>
                <div class="col-sm-6">
                    <button class="btn btn-primary" ng-click="addUser()"><i class="fa fa-floppy"></i> User zum Team hinzufügen</button>
                </div>
            </div>
        </fieldset>
    </form>
    
    <table class="table table-inverse m-t">
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
                    <a class="btn btn-info" href="/com.Nephthys.user#/{{member.userId}}"><i class="fa fa-eye"></i></a>
                    <button class="btn btn-danger" ng-click="removeMember(member.memberId)"><i class="fa fa-trash"></i></button>
                    <button class="btn btn-primary" ng-click="sortUp(member.memberId)" ng-if="! $first"><i class="fa fa-arrow-up"></i></button>
                    <button class="btn btn-primary" ng-click="sortDown(member.memberId)" ng-if="! $last"><i class="fa fa-arrow-down"></i></button>
                </td>
            </tr>
        </tbody>
    </table>
</div>