#!/usr/bin/python
import string
import random
import mysql.connector as mariadb


class TestData:
    config = {
        'host': '127.0.0.1',
        'user': 'root',
        'password': '123456',
        'database': 'test_index'
    }

    def construct(self, num):
        data = []
        for i in range(num):
            code = 50 + i
            name = ''.join(random.choice(string.ascii_letters) for _ in range(10))
            price = random.randint(10, 100000)
            manufacturer_key = random.randint(1, 6)
            data.append("({},'{}',{},{})".format(code, name, price, manufacturer_key))
        return data

    
    def load(self):
        cnx = mariadb.connect(**self.config)
        cursor = cnx.cursor()

        data = self.construct(300000)
        sql_list = [
            "INSERT INTO `Manufacturers` VALUES (1,'Sony'),(2,'Creative Labs'),(3,'Hewlett-Packard'),(4,'Iomega'),(5,'Fujitsu'),(6,'Winchester');",
            "INSERT INTO `Products` VALUES (1,'Hard drive',240,5),(2,'Memory',120,6),(3,'ZIP drive',150,4),(4,'Floppy disk',5,6),(5,'Monitor',240,1),(6,'DVD drive',180,2),(7,'CD drive',90,2),(8,'Printer',270,3),(9,'Toner cartridge',66,3),(10,'DVD burner',180,2);",
            "INSERT INTO `Products` VALUES {};".format(','.join(data))
        ]
        for sql in sql_list:
            cursor.execute(sql)

        cnx.commit()
        cnx.close()


td = TestData()
td.load()
