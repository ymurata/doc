# -*- coding: utf-8 -*-
from optparse import OptionParser
# import logparser.parser as parser
import logparser.walkdirectory as walkDir


def option():
    op = OptionParser()
    op.add_option("-p", "--path", dest="path", help="target log directory of path")
    op.add_option("-t", "--toDate", dest="toDate", help="to date")
    op.add_option("-f", "--fromDate", dest="fromDate", help="from date")

    return op.parse_args()


if __name__ == "__main__":
    opt, args = option()
    if opt.path is None:
        print("should be add -p option")
    else:
        wd = walkDir.Walk(opt.path)
        files = wd.getFiles()
