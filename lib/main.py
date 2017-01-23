# encoding=utf-8
import sys
import Taiba
def main():
    message = unicode(sys.argv[1], 'utf-8')
    seg = Taiba.lcut(message, CRF=True)
    result = repr([x.encode('utf-8') for x in seg]).decode('string-escape')
    print(result)
    return

if __name__ == "__main__":
    main()
