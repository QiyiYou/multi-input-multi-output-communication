function [txStreamSplit, rxStreamSplit, nPairs] = qpsk_system(iSnr, nTxRx, nChannels, nBits, channelMatrix)
variance = 1;
pskNumber = 4;
bitsPerSymbol = log2(pskNumber);
nSymbols = nBits / bitsPerSymbol;
nPairs = nSymbols / nTxRx;
rxStreamSplit = cell(nChannels, 1);
% binary bit sequence
bitStream = round(rand(1, nBits));
% bpsk sequence
demultiplexedStream = reshape(bitStream, bitsPerSymbol, nSymbols);
txStream = demultiplexedStream(1, :) + 1i * demultiplexedStream(2, :);
% split data for mimo: dimension is (number of tx) * (symbols per tx), each
% row correspond to the data handled by an tx antenna
txStreamSplit = reshape(txStream, nTxRx, nPairs);
noiseSplit = sqrt(variance / 2) * (randn(nTxRx, nPairs) + 1i * randn(nTxRx, nPairs));
% noiseSplit = reshape(noise, nTxRx, nPairs);
for iChannel = 1: nChannels
    rxStreamSplit{iChannel} = sqrt(iSnr / nTxRx) * channelMatrix{iChannel} * txStreamSplit + noiseSplit;
end
end
