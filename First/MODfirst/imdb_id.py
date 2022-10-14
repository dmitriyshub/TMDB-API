# importing the module
import imdb

def imdb_movie_id(name):
    """
    :param name: name of the movie string
    :return: list of all ids that returns from search
    """
    list_ids = []
    ia = imdb.IMDb()
    search = ia.search_movie(name)
    for i in range(len(search)):
        # getting the id
        id = search[i].movieID
        # print(id)

        list_ids.append(id)
        # printing it
        #print(search[i]['title'] + " : " + id)

    return list_ids



# # creating instance of IMDb
# ia = imdb.IMDb()
#
# # name
#
# # searching the name
# search = ia.search_movie(name)
# list_ids = []
# # loop for printing the name and id
# for i in range(len(search)):
#     # getting the id
#     id = search[i].movieID
#     #print(id)
#
#     list_ids.append(id)
#     # printing it
#     print(search[i]['title'] + " : " + id)
# print(list_ids)