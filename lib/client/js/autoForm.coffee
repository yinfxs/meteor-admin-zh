# Add hooks used by many forms
AutoForm.addHooks [
		'admin_insert',
		'admin_update',
		'adminNewUser',
		'adminUpdateUser',
		'adminSendResetPasswordEmail',
		'adminChangePassword'],
	beginSubmit: ->
		$('.btn-primary').addClass('disabled')
	endSubmit: ->
		$('.btn-primary').removeClass('disabled')
	onError: (formType, error)->
		AdminDashboard.alertFailure error.message

AutoForm.hooks
	admin_insert:
		onSubmit: (insertDoc, updateDoc, currentDoc)->
			hook = @
			Meteor.call 'adminInsertDoc', insertDoc, Session.get('admin_collection_name'), (e,r)->
				if e
					hook.done(e)
				else
					adminCallback 'onInsert', [Session.get 'admin_collection_name', insertDoc, updateDoc, currentDoc], (collection) ->
						hook.done null, collection
			return false
		onSuccess: (formType, collection)->
			AdminDashboard.alertSuccess '新增成功'
			Router.go "/admin/#{collection}"

	admin_update:
		onSubmit: (insertDoc, updateDoc, currentDoc)->
			hook = @
			Meteor.call 'adminUpdateDoc', updateDoc, Session.get('admin_collection_name'), Session.get('admin_id'), (e,r)->
				if e
					hook.done(e)
				else
					adminCallback 'onUpdate', [Session.get 'admin_collection_name', insertDoc, updateDoc, currentDoc], (collection) ->
						hook.done null, collection
			return false
		onSuccess: (formType, collection)->
			AdminDashboard.alertSuccess '更新成功'
			Router.go "/admin/#{collection}"

	adminNewUser:
		onSuccess: (formType, result)->
			AdminDashboard.alertSuccess '新增用户成功'
			Router.go '/admin/Users'

	adminUpdateUser:
		onSubmit: (insertDoc, updateDoc, currentDoc)->
			Meteor.call 'adminUpdateUser', updateDoc, Session.get('admin_id'), @done
			return false
		onSuccess: (formType, result)->
			AdminDashboard.alertSuccess '更新用户成功'
			Router.go '/admin/Users'

	adminSendResetPasswordEmail:
		onSuccess: (formType, result)->
			AdminDashboard.alertSuccess '邮件发送成功'

	adminChangePassword:
		onSuccess: (operation, result, template)->
			AdminDashboard.alertSuccess '重置密码成功'
