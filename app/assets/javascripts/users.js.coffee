# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("[data-auto-commit]").each () ->
    submitButton = $(this)
    submitButton.hide()
    form = $(this).parents('form')
    form.find('input').on 'change', () ->
      submitButton.click()

