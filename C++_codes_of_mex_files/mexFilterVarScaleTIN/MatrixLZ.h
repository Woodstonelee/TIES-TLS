#pragma once
#ifndef _MATRIXLZ_H_
#define _MATRIXLZ_H_
namespace MatrixLZ
{
  // !!!All the subcripts, indices are based from zero!!!
  enum Order
  {
    ColMajor,
    RowMajor,
  };
  inline unsigned int sub2ind (unsigned int _row, unsigned int _col,
                               unsigned int _rownum, unsigned int _colnum,
                               MatrixLZ::Order _giveOrder)
  {
    if (_giveOrder == MatrixLZ::ColMajor) {
      return _col * _rownum + _row;
    }
    if (_giveOrder == MatrixLZ::RowMajor) {
      return _row * _colnum + _col;
    }
    return -1;
  }

  inline unsigned int ind2subrow (unsigned int _index, unsigned int _rownum,
                                  unsigned int _colnum,
                                  MatrixLZ::Order _giveOrder)
  {
    if (_giveOrder == MatrixLZ::ColMajor) {
      return _index % _rownum;
    }
    if (_giveOrder == MatrixLZ::RowMajor) {
      return _index / _colnum;
    }
    return -1;
  }

  inline unsigned int ind2subcol (unsigned int _index, unsigned int _rownum,
                                  unsigned int _colnum,
                                  MatrixLZ::Order _giveOrder)
  {
    if (_giveOrder == MatrixLZ::ColMajor) {
      return _index / _rownum;
    }
    if (_giveOrder == MatrixLZ::RowMajor) {
      return _index % _colnum;
    }
    return -1;
  }
}
#endif
