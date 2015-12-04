# -*- coding: utf-8 -*-
import os


class Walk:

    def __init__(self, path):
        self.path = path
        # self.regexp = regexp

    def getFiles(self):
        res = []
        for root, dirs, files in os.walk(self.path):
            for file in files:
                res.append(os.path.join(root, file))

        return res
