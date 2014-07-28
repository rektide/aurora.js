Decoder = require '../decoder'

class UnencodedDecoder extends Decoder
    Decoder.register 'unencoded', UnencodedDecoder

    readChunk: ->
        return @stream.readSingleBuffer(Number.MAX_VALUE)
