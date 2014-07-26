whenn = require 'when'
buffer = require '../core/buffer'

class WebAudioSource extends EventEmitter
    constructor: (@input, @options = {}) ->
        @options.bufferSize ||= 2048
        @options.channels ||=  1
        @counter = 0

    start: () ->
        if not @input?
            throw 'No input element defined'
        whenn @input (audioInputNode) =>

            emit = @emit
            emitData = switch @options.channels
                when 1 then (e) ->
                    emit 'data', new buffer(e.inputBuffer.getChannelData 0)
                when 2 then (e) ->
                    emit 'data', new buffer(e.inputBuffer.getChannelData 0), new buffer(e.inputBuffer.getChannelData 1)
                else (e) ->
                    dataEvent = ['data']
                    for i in [0..e.inputBuffer.numberOfChannels-1] by 1
                        channelData = new buffer(e.inputBuffer.getChannelData i)
                    emit dataEvent...

            context = audioInputNode.context
            recorderNode = context.createScriptProcessor @options.bufferSize, @options.channels, 0
            recorderNode.onaudioprocess = emitData
            audioInputNode.connect recorderNode

    pause: ->

    reset: ->

