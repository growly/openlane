#!/usr/bin/env python3
# Hello and welcome to my proof of concept?

from optparse import OptionParser
import os
import sys

import pyverilog
from pyverilog.vparser.parser import parse
from pyverilog.dataflow.dataflow_analyzer import VerilogDataflowAnalyzer

optparser = OptionParser()
optparser.add_option('-v', '--version', action='store_true', dest='showversion',
                     default=False, help='Show the version')
optparser.add_option('-I', '--include', dest='include', action='append',
                     default=[], help='Include path')
optparser.add_option('-D', dest='define', action='append',
                     default=[], help='Macro Definition')
optparser.add_option('-t', '--top', dest='topmodule',
                     default='mac_tile', help='Top module, Default=mac_tile')
optparser.add_option('--nobind', action='store_true', dest='nobind',
                     default=False, help='No binding traversal, Default=False')
optparser.add_option('--noreorder', action='store_true', dest='noreorder',
                     default=False, help='No reordering of binding dataflow, Default=False')
options, args = optparser.parse_args()


def main():
    def show_version():
        print('lol')

    filelist = args
    if options.showversion:
        show_version()

    for f in filelist:
        if not os.path.exists(f):
            raise IOError('file not found: ' + f)

    if len(filelist) == 0:
        show_version()

    analyzer = VerilogDataflowAnalyzer(filelist, options.topmodule,
                                       noreorder=options.noreorder,
                                       nobind=options.nobind,
                                       preprocess_include=options.include,
                                       preprocess_define=options.define)
    analyzer.generate()

    directives = analyzer.get_directives()
    print('Directive:')
    for dr in sorted(directives, key=lambda x: str(x)):
        print(dr)

    instances = analyzer.getInstances()
    print('Instance:')
    for module, instname in sorted(instances, key=lambda x: str(x[1])):
        print((module, instname))

    if options.nobind:
        print('Signal:')
        signals = analyzer.getSignals()
        for sig in signals:
            print(sig)

        print('Const:')
        consts = analyzer.getConsts()
        for con in consts:
            print(con)

    else:
        terms = analyzer.getTerms()
        print('Term:')
        for tk, tv in sorted(terms.items(), key=lambda x: str(x[0])):
            print(tv.tostr())

        binddict = analyzer.getBinddict()
        print('Bind:')
        for bk, bv in sorted(binddict.items(), key=lambda x: str(x[0])):
            for bvi in bv:
                print(bvi.tostr())


def parse_demo():
    file_list = args
    for f in file_list:
        if not os.path.exists(f):
            raise IOError('file not found: %s'.format(f))
    
    ast, directives = parse(file_list,
                            preprocess_include=options.include,
                            preprocess_define=options.define)
    ast.show()

    for lineno, directive in directives:
        print('Line %d : %s' % (lineno, directive))



if __name__ == '__main__':
    main()
