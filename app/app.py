
import json

from flask import Flask, session, url_for, redirect, render_template, request, abort, flash
from db import list_users, verify, delete_user_from_db, add_user, get_users


app = Flask(__name__)
app.config.from_object('config')



@app.errorhandler(401)
def FUN_401(error):
    return render_template("page_401.html"), 401

@app.errorhandler(403)
def FUN_403(error):
    return render_template("page_403.html"), 403

@app.errorhandler(404)
def FUN_404(error):
    return render_template("page_404.html"), 404

@app.errorhandler(405)
def FUN_405(error):
    return render_template("page_405.html"), 405

@app.errorhandler(413)
def FUN_413(error):
    return render_template("page_413.html"), 413





@app.route("/")
def FUN_root():
    return render_template("index.html")

@app.route("/health")
def FUN_health():
    return json.dumps({'success':True}), 200, {'ContentType':'application/json'}

@app.route("/metrics")
def FUN_metrics():
    return json.dumps({'success':True}), 200, {'ContentType':'application/json'}

@app.route("/users/")
def FUN_user_dashboard():
    if session.get("current_user", None) != None:
        user_list = get_users()
        user_table = zip([x[0] for x in user_list], \
                         [x[1] for x in user_list], \
                         [x[2] for x in user_list], \
                         [x[3] for x in user_list], \
                         [x[4] for x in user_list], \
                         [x[5] for x in user_list], \
                         [x[6] for x in user_list], \
                         [x[7] for x in user_list], \
                         ["/delete_user/" + x[5] for x in user_list])
        return render_template("users.html", users = user_table)
    else:
        return abort(401)

@app.route("/admin/")
def FUN_user_management():
    if session.get("current_user", None) == "admin":
        return render_template("admin.html")
    else:
        return abort(401)


@app.route("/login", methods = ["POST"])
def FUN_login():
    id_submitted = request.form.get("id").lower()
    if (id_submitted in list_users()) and verify(id_submitted, request.form.get("pw")):
        session['current_user'] = id_submitted


    return(redirect(url_for("FUN_root")))

@app.route("/logout/")
def FUN_logout():
    session.pop("current_user", None)
    return(redirect(url_for("FUN_root")))

@app.route("/delete_user/<id>/", methods = ['GET'])
def FUN_delete_user(id):
    if session.get("current_user", None) == "admin":
        if id == "admin": # ADMIN account can't be deleted.
            return abort(403)

        delete_user_from_db(id)
        return(redirect(url_for("FUN_user_dashboard")))
    else:
        return abort(401)

@app.route("/add_user", methods = ["POST"])
def FUN_add_user():
    if session.get("current_user", None) == "admin": # only Admin should be able to add user.
        # before we add the user, we need to ensure this is doesn't exsit in database. We also need to ensure the id is valid.
        if request.form.get('username').lower() in list_users():
            user_list = list_users()
            user_table = zip(range(1, len(user_list)+1), \
                             user_list, \
                             [x + y for x,y in zip(["/delete_user/"] * len(user_list), user_list)])
            return(render_template("admin.html", id_to_add_is_duplicated = True, users = user_table))
        if " " in request.form.get('username') or "'" in request.form.get('username'):
            user_list = list_users()
            user_table = zip(range(1, len(user_list)+1), \
                             user_list, \
                             [x + y for x,y in zip(["/delete_user/"] * len(user_list), user_list)])
            return(render_template("admin.html", id_to_add_is_invalid = True, users = user_table))
        else:
            add_user(
                request.form.get('title'),
                request.form.get('firstname'),
                request.form.get('lastname'),
                request.form.get('username'),
                request.form.get('password'),
                request.form.get('age')
            )
            return(redirect(url_for("FUN_user_dashboard")))
    else:
        return abort(401)



if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")