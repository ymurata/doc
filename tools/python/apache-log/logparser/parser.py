# -*- coding: utf-8 -*-
# import apache_log_parser as parser


class LogParser:

    def __init__(self, regexp, files):
        self.regexp = regexp
        self.files = files

    def executer(self):
        # p = parser.make_parser(self.regexp)
        for file in self.files:
            for line in open(file):
                print(line)
