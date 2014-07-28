Demuxer = require '../demuxer'
AudioSource = require '../sources/browser/audioSource'

class UnencodedDemuxer extends Demuxer
    Demuxer.register(UnencodedDemuxer)

    @probe: (buffer) ->
        return false if buffer.length != AudioSource.MagicBuffer.length + AudioSource.Format.length
        for i in [0..AudioSource.MagicBuffer.length - 1] by 1
            return false if buffer[0] != AudioSource.MagicBuffer[0]
        return true

    readChunk: ->
        if @readHeader
            @emit 'data', @stream.readSingleBuffer(Number.MAX_VALUE)
            return
            
        if not @readHeader and @stream.available(4*AudioSource.MagicBuffer.length)
            return @emit 'error', 'Invalid AudioSource'
 
        for i in [0..AudioSource.MagicBuffer.length-2] by 1
            @stream.readFloat32()

        @format =
            formatID: 'unencoded'
            littleEndian: false
            floatingPoint: true
        for i in [0..AudioSource.Format.length-1] by 1
            key = AudioSource.Format[i]
            @format[key] = stream.readFloat32()
        @format.bytesPerPacket = (@format.bitsPerChannel / 8) * @format.channelsPerFrame
        @emit 'format', @format
        @readHeader = true
            
            
        
        
