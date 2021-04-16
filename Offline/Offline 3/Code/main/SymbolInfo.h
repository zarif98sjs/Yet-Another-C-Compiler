
#ifndef SYMBOLINFO_H
#define SYMBOLINFO_H

#include<bits/stdc++.h>
using namespace std;

struct SymbolInfo
{
    string key;
    string val;
    string var_type;

    SymbolInfo* nxt;

    int bucket;
    int bucket_pos;

    SymbolInfo();

    SymbolInfo(string key,string val);

    SymbolInfo(string key,string val,SymbolInfo* nxt);

    void setVarType(string var_type);
};

#endif // SYMBOLINFO_H
