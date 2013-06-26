Augury.Routers.Schedulers = Backbone.Router.extend(
  initialize: (options) ->
    @collection = options.collection

  routes:
    "schedulers": "index"
    "schedulers/new": "new"
    "schedulers/:id/edit": "edit"
    "schedulers/delete/:id?confirm=:confirm": "delete"

  index: (integration_id) ->
    Augury.update_nav('schedulers')

    schedulers = @collection

    view = new Augury.Views.Schedulers.Index(collection: schedulers)
    $("#integration_main").html view.render().el

  new: ->
    Augury.update_nav('schedulers')

    scheduler = new Augury.Models.Scheduler
    Augury.schedulers.add scheduler
    view = new Augury.Views.Schedulers.Edit(model: scheduler, keys: Augury.keys)
    $("#integration_main").html view.render().el

  edit: (id) ->
    Augury.update_nav('schedulers')

    scheduler = @collection.get(id)
    view = new Augury.Views.Schedulers.Edit(model: scheduler, keys: Augury.keys)
    $("#integration_main").html view.render().el

  delete: (id, confirm) ->
    scheduler = @collection.get(id)
    if confirm != 'true'
      dialog = JST['admin/templates/shared/confirm_delete']
      $.modal(dialog(klass: 'schedulers', warning: 'Are you sure you want to delete this Scheduler?', identifier: id))
    else
      $.modal.close()
      scheduler.destroy()
      Augury.schedulers.remove scheduler
      Backbone.history.navigate '/schedulers', trigger: true
)
