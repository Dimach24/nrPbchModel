## Table of content

- [Table of content](#table-of-content)
- [`+nrCom`](#nrcom)
- [Generating and receiving instructions](#generating-and-receiving-instructions)
  - [Generating](#generating)
  - [Receiving](#receiving)

## `+nrCom`

Namespace `nrCom` includes most of necessary constants and functions:

- Enumerators:
  - `CellBarred`
  - `CrcType`
  - `DmrsTypeAPosition`
  - `IntraFreqReselection`
  - `PbchCrcType`
  - `ScsCommon`
- Constants:
  - `Kil_max`
  - `Nbits_pbch`
  - `Nfref`
  - `Nsc_rb`
  - `Nsubframe_frame`
  - `Nsymb_slot`
  - `Nsymb_slotExtCP`
  - `PbchPayloadInterleavingPattern`
  - `PolarCodingInterleavingPattern`
  - `PolarSequenceReliability`
  - `Tc`
  - `Ts`
  - `dFref`
  - `kappa`
- Functions for constant parameters
  - `Nslot_frame`
  - `Nslot_subframe`
  - `blocksByCase`
  - `nidByCellId`

## Generating and receiving instructions

### Generating

For bitstream generation should be used `genPayload`, that takes named params and places it into 32-bit vector. Then to this vector should be applied `genPbch`, that produces 864-length vector of bits, that should be modulated and mapped.

For modulation `qpskModulate` should be used. Modulated RE should be mapped to resource grid on blocks with `ResourceMapper.mapBlock`.

### Receiving
