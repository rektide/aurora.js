whenn = require 'when'
Buffer = require '../core/Buffer'

class WebAudioSource extends EventEmitter
    @Format: ['bitsPerChannels', 'sampleRate', 'channelsPerFrame', 'framesPerPacket']
    @MagicBuffer: [1.6, 1.61, 1.618]

    constructor: (@input, @options = {}) ->
        @options.bufferSize ||= 2048
        @options.channels ||=  1
        @counter = 0

    start: () ->
        if not @input?
            throw 'No input element defined'
        whenn @input (audioInputNode) =>

            # find appropriate handler
            emit = @emit
            emitData = switch @options.channels
                when 1 then (e) ->
                    emit 'data', new Buffer(e.inputBuffer.getChannelData 0)
                when 2 then (e) ->
                    emit 'data', new Buffer(e.inputBuffer.getChannelData 0), new Buffer(e.inputBuffer.getChannelData 1)
                else (e) ->
                    dataEvent = ['data']
                    for i in [0..e.inputBuffer.numberOfChannels-1] by 1
                        channelData = new Buffer(e.inputBuffer.getChannelData i)
                    emit dataEvent...

            context = audioInputNode.context
            recorderNode = context.createScriptProcessor @options.bufferSize, @options.channels, 0
            recorderNode.onaudioprocess = emitData
            audioInputNode.connect recorderNode

            # signal
            signal = @MagicBuffer.slice(0)
            signal.push(
                32
                context.sampleRate
                @options.channels
                @options.BufferSize
            )
            @emit 'data', new Buffer(new Float32Array(signal))

    pause: ->

    reset: ->

