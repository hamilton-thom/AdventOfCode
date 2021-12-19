# -*- coding: utf-8 -*-
"""
Created on Thu Dec 16 07:29:08 2021

@author: choes
"""

input = "420D74C3088043390499ED709E6EB49A5CC4A3A3898B7E0F44011C4CC48AC0119D049B0C500265EB8F615900180910C88129B2F0007C61C4B7F74ED7396B20020A44A4C014D005E5A72E274B4E5C4B96CC3793410078C01D82F1DA08180351661AC1920042A3CC578BA6008F802138D93352B9CFCEF61D3009A7D2268D254925569C02A92D62BF108D52C1B3E4B257B57FAE5C54400A84840267880311D23245F1007A35C79848200C4288FF0E8C01194A4E625E00A4EFEF5F5996486C400C5002800BFA402D3D00A9C4027B98093D602231C00F001D38C009500258057E601324C00D3003D400C7003DC00A20053A6F1DBDE2D4600A6802B37C4B9E872B0E44CA5FF0BFB116C3004740119895E6F7312BCDE25EF077700725B9F2B8F131F333005740169A7F92EFEB3BC8A21998027400D2CDF30F927880B4C62D6CDFFD88EB0068D2BF019A8DAAF3245B39C9CFA1D2DF9C3DB9D3E50A0164BE2A3339436993894EC41A0D10020B329334C62016C8E7A5F27C97D0663982D8EB23C5282529CDD271E8F100AE1401AA80021119E3A4511006E1E47689323585F3AEBF900AEB2B6942BD91EE8028000874238AB0C00010B8D913220A004A73D789C4D54E24816301802538E940198880371AE15C1D1007638C43856C00954C25CD595A471FE9D90056D60094CEA61933A9854E9F3801F2BBC6131001F792F6796ACB40D036605C80348C005F64F5AC374888CA42FD99A98025319EB950025713656F202200B767AB6A30E802D278F81CBA89004CD286360094FC03A7E01640245CED5A3C010100660FC578B60008641C8B105CC017F004E597E596E633BA5AB78B9C8F840C029917C9E389B439179927A3004F003511006610C658A200084C2989D0AE67BD07000606154B70E66DC0C01E99649545950B8AB34C8401A5CDA050043D319F31CB7EBCEE14"

input = "D2FE28"

hexMap = {
    "0": [0, 0, 0, 0],
    "1": [0, 0, 0, 1],
    "2": [0, 0, 1, 0],
    "3": [0, 0, 1, 1],
    "4": [0, 1, 0, 0],
    "5": [0, 1, 0, 1],
    "6": [0, 1, 1, 0],
    "7": [0, 1, 1, 1],
    "8": [1, 0, 0, 0],
    "9": [1, 0, 0, 1],
    "A": [1, 0, 1, 0],
    "B": [1, 0, 1, 1],
    "C": [1, 1, 0, 0],
    "D": [1, 1, 0, 1],
    "E": [1, 1, 1, 0],
    "F": [1, 1, 1, 1]
    }
    

def fromHex(string): # should be called fromHex
    returnList = []
    for char in string:
        returnList += hexMap[char]
    return returnList


def bitListToInt(bitList):
    stringList = "".join([str(i) for i in bitList])
    return int(stringList, 2)


def decodeInt(bitString):
    
    totalLength = len(bitString)
    chunkCount = totalLength // 5
    if chunkCount == 0:
        raise ValueError("Chunk count == 0 - warning")
    
    intChunkCount = None
    for i in range(chunkCount):
        if bitString[5 * i] == 0:
            intChunkCount = i + 1
            break
    
    if intChunkCount is None:
        raise ValueError("No chunks found")
    
    integerBits = []
    for chunkId in range(intChunkCount):
        integerBits += bitString[(chunkId * 5 + 1): (chunkId + 1) * 5]
    
    remainingBits = bitString[(5 * intChunkCount):]    
    return (bitListToInt(integerBits), remainingBits)
    

def printBits(bitList):
    print("".join([str(i) for i in bitList]))


def decodeGenericOperator(bitString):
    """Note that the bitstring here is everything except the header.
    Returns a list of all sub-packets.
    """
    lengthType = bitString[0]
    
    if lengthType == 0: # Length of all packets
      subpacketBitCount = bitListToInt(bitString[1:16])
      
      subpacketBits = bitString[16:(16 + subpacketBitCount)]
      remainingBits = bitString[(16 + subpacketBitCount):]
      
      return (parseBitString(subpacketBits), remainingBits)
      
    
    elif lengthType == 1: # Count of all packets
        subpacketCount = bitListToInt(bitString[1:12])
        
        output = []
        
        restOfString = bitString[12:]
        packetsDecoded = 0
        
        while packetsDecoded < subpacketCount:        
            thisPacket, restOfString = parseBitString(restOfString)        
            output.append(thisPacket)
            packetsDecoded += 1
        
        return (output, restOfString)
    
    raise ValueError("Shouldn't be here.")

versionSum = None

def parseBitString(bitString):
    version = bitListToInt(bitString[0:3])
    global versionSum    
    if versionSum is None:
        versionSum = version
    else:
        versionSum += version
    
    typeId = bitListToInt(bitString[3:6])
    
    remainingBits = bitString[6:]
    
    if typeId == 4:
        return decodeInt(remainingBits)
    
    else: # Operator
        return decodeGenericOperator(remainingBits)


example1 = "D2FE28" # Pure int
example2 = "38006F45291200" # Operator Two sub-packets
example3 = "EE00D40C823060" # Operator Three sub-packets

def runExample(input):
    bitString = fromHex(input)
    return parseBitString(bitString)

runExample(example1)
runExample(example2)
runExample(example3)

