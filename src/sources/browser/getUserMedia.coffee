whenn = require 'when'
getUserMedia = require 'getUserMedia'
WebAudioSource = require './audioSource'

class UserMediaSource extends WebAudioSource
    constructor: (userMedia, @options) ->
        if userMedia?
            @userMedia = whenn userMedia
        @options.context ||= window.AudioContext || window.webkitAudioContext
        @options.audio ?= true
        @options.video ?= true

    start: ->
        if not @userMedia?
            @userMedia = whenn.call getUserMedia {audio:@options.audio, video:@options.video}
        @input = @userMedia.then (userMedia) =>
             return @context.createMediaStreamSource userMedia
        @start()

     pause: ->

     reset: ->
 
